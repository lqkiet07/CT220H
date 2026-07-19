/// ============================================================
/// RECOMMENDATION ENGINE – User-Based Collaborative Filtering
/// ============================================================
///
/// Thuật toán: So sánh profile sở thích (genre) của user hiện tại
/// với toàn bộ user khác, tính điểm tương đồng bằng Jaccard Similarity,
/// rồi gộp và xếp hạng các bộ phim mà nhóm "láng giềng" thích.
///
/// Jaccard Similarity: |A ∩ B| / |A ∪ B|
///   → Đo độ trùng lặp tập thể loại phim yêu thích giữa 2 người.
///
/// Độ phức tạp: O(U × M) – U: số users, M: số movies
/// ============================================================

import '../../data/models/movie.dart';
import '../../data/models/user.dart';

class RecommendationEngine {
  /// Ngưỡng điểm tương đồng tối thiểu để xét là "láng giềng"
  static const double _similarityThreshold = 0.1;

  /// Số lượng "láng giềng" tối đa để tham khảo
  static const int _maxNeighbors = 10;

  // ─────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────

  /// Trả về danh sách phim được gợi ý cho [currentUser].
  ///
  /// [allMovies]    – Toàn bộ phim trong hệ thống.
  /// [allUsers]     – Toàn bộ user (để so sánh sở thích).
  /// [genreHistory] – Danh sách thể loại user hiện tại đã xem/thích.
  ///                  (Ví dụ: ['Action', 'Drama', 'Sci-Fi'])
  /// [topN]         – Số phim gợi ý muốn trả về (mặc định: 6).
  static List<MovieRecommendation> recommend({
    required User currentUser,
    required List<Movie> allMovies,
    required List<User> allUsers,
    required List<String> genreHistory,
    int topN = 6,
  }) {
    if (genreHistory.isEmpty || allMovies.isEmpty) return [];

    // Tập genre của user hiện tại (chuẩn hóa chữ thường)
    final Set<String> currentGenres =
        genreHistory.map((g) => g.toLowerCase()).toSet();

    // Tập ID phim user hiện tại đã thích (để không gợi ý lại)
    final Set<String> alreadyLiked = currentUser.favoriteMovieIds.toSet();

    // ── BƯỚC 1: Tính điểm tương đồng với từng user khác ──────
    final List<_UserSimilarity> neighbors = [];

    for (final otherUser in allUsers) {
      // Bỏ qua chính mình
      if (otherUser.id == currentUser.id) continue;

      // Lấy genre của user khác (từ favoriteMovieIds → movies → genres)
      final Set<String> otherGenres = _extractGenres(
        otherUser.favoriteMovieIds,
        allMovies,
      );

      if (otherGenres.isEmpty) continue;

      final double similarity = _jaccardSimilarity(currentGenres, otherGenres);

      if (similarity >= _similarityThreshold) {
        neighbors.add(_UserSimilarity(user: otherUser, score: similarity));
      }
    }

    // Sắp xếp giảm dần theo điểm tương đồng, lấy top N láng giềng
    neighbors.sort((a, b) => b.score.compareTo(a.score));
    final topNeighbors = neighbors.take(_maxNeighbors).toList();

    // ── BƯỚC 2: Tổng hợp điểm cho từng bộ phim ──────────────
    // Điểm của một phim = tổng (similarity × 1) của các láng giềng đã thích phim đó
    final Map<String, double> movieScores = {};

    for (final neighbor in topNeighbors) {
      for (final movieId in neighbor.user.favoriteMovieIds) {
        // Bỏ qua phim user đã thích
        if (alreadyLiked.contains(movieId)) continue;

        movieScores[movieId] =
            (movieScores[movieId] ?? 0.0) + neighbor.score;
      }
    }

    if (movieScores.isEmpty) {
      // Fallback: Gợi ý theo genre trùng khớp nếu không tìm được láng giềng
      return _fallbackByGenre(
        currentGenres: currentGenres,
        allMovies: allMovies,
        alreadyLiked: alreadyLiked,
        topN: topN,
      );
    }

    // ── BƯỚC 3: Map movieId → Movie object và sắp xếp ────────
    final List<MovieRecommendation> result = [];

    for (final entry in movieScores.entries) {
      try {
        final movie = allMovies.firstWhere((m) => m.id == entry.key);
        result.add(
          MovieRecommendation(
            movie: movie,
            score: entry.value,
            reason: _buildReason(movie.genres, currentGenres),
          ),
        );
      } catch (_) {
        // Movie ID không tìm thấy → bỏ qua
      }
    }

    result.sort((a, b) => b.score.compareTo(a.score));
    return result.take(topN).toList();
  }

  // ─────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────────

  /// Jaccard Similarity: |A ∩ B| / |A ∪ B|
  /// Kết quả trong khoảng [0.0, 1.0].
  static double _jaccardSimilarity(Set<String> a, Set<String> b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final int intersectionSize = a.intersection(b).length;
    final int unionSize = a.union(b).length;
    return intersectionSize / unionSize;
  }

  /// Trích xuất tập genre từ danh sách movieId
  static Set<String> _extractGenres(
    List<String> movieIds,
    List<Movie> allMovies,
  ) {
    final Set<String> genres = {};
    for (final id in movieIds) {
      try {
        final movie = allMovies.firstWhere((m) => m.id == id);
        genres.addAll(movie.genres.map((g) => g.toLowerCase()));
      } catch (_) {}
    }
    return genres;
  }

  /// Fallback: Gợi ý theo genre trùng khớp, xếp hạng bằng số genre chung × rating
  static List<MovieRecommendation> _fallbackByGenre({
    required Set<String> currentGenres,
    required List<Movie> allMovies,
    required Set<String> alreadyLiked,
    required int topN,
  }) {
    final List<MovieRecommendation> result = [];

    for (final movie in allMovies) {
      if (alreadyLiked.contains(movie.id)) continue;

      final movieGenres = movie.genres.map((g) => g.toLowerCase()).toSet();
      final int genreMatch = currentGenres.intersection(movieGenres).length;

      if (genreMatch > 0) {
        // Score = số genre trùng × rating phim (chuẩn hóa về 1.0)
        final double score = genreMatch * (movie.rating / 10.0);
        result.add(
          MovieRecommendation(
            movie: movie,
            score: score,
            reason: _buildReason(movie.genres, currentGenres),
          ),
        );
      }
    }

    result.sort((a, b) => b.score.compareTo(a.score));
    return result.take(topN).toList();
  }

  /// Tạo chuỗi lý do gợi ý, hiển thị trên UI
  static String _buildReason(
    List<String> movieGenres,
    Set<String> userGenres,
  ) {
    final matched = movieGenres
        .where((g) => userGenres.contains(g.toLowerCase()))
        .take(2)
        .join(', ');

    return matched.isNotEmpty ? 'Vì bạn thích $matched' : 'Được gợi ý cho bạn';
  }
}

// ─────────────────────────────────────────────────────────────
// DATA CLASSES
// ─────────────────────────────────────────────────────────────

/// Kết quả gợi ý phim, gồm điểm số và lý do
class MovieRecommendation {
  final Movie movie;

  /// Điểm tương đồng tổng hợp (càng cao càng phù hợp)
  final double score;

  /// Lý do gợi ý hiển thị trên UI
  final String reason;

  const MovieRecommendation({
    required this.movie,
    required this.score,
    required this.reason,
  });

  @override
  String toString() =>
      'MovieRecommendation(${movie.title}, score: ${score.toStringAsFixed(3)}, reason: $reason)';
}

/// Lưu trữ tạm thông tin độ tương đồng giữa 2 users
class _UserSimilarity {
  final User user;
  final double score;
  const _UserSimilarity({required this.user, required this.score});
}
