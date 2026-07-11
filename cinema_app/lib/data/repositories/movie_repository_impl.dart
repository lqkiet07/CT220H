import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/movie_repository.dart';
import '../models/movie.dart'; // Đảm bảo import đúng model Movie của bạn

class MovieRepositoryImpl implements MovieRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MovieRepositoryImpl(); // Xóa ApiService trong constructor cũ nếu có

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      // Lấy các phim có đánh dấu là trending (hoặc lấy đại 5 phim mới nhất)
      final snapshot = await _firestore
          .collection('movies')
          .orderBy('rating', descending: true) // Sắp xếp theo điểm đánh giá giảm dần
          .limit(5)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Gán ID của document làm ID của Model
        return Movie.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi lấy danh sách phim hot: $e');
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      // Tìm các phim có trạng thái 'now_playing' trên Firestore
      final snapshot = await _firestore
          .collection('movies')
          .where('status', isEqualTo: 'now_playing')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Movie.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi lấy danh sách phim đang chiếu: $e');
    }
  }

  @override
  Future<List<Movie>> getComingSoonMovies() async {
    try {
      // Tìm các phim có trạng thái 'coming_soon' trên Firestore
      final snapshot = await _firestore
          .collection('movies')
          .where('status', isEqualTo: 'coming_soon')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Movie.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi lấy danh sách phim sắp chiếu: $e');
    }
  }
  @override
  Future<Movie> getMovieDetail(String movieId) async {
    try {
      final doc = await _firestore.collection('movies').doc(movieId).get();
      if (!doc.exists || doc.data() == null) throw Exception('Không tìm thấy phim');

      final data = doc.data()!;
      data['id'] = doc.id;
      return Movie.fromJson(data);
    } catch (e) {
      throw Exception('Lỗi lấy chi tiết phim: $e');
    }
  }

  @override
  Future<void> addMovie(Movie movie) async {
    try {
      // Ép kiểu object Movie thành Map (JSON) để lưu lên Firebase
      await _firestore.collection('movies').add(movie.toJson());
    } catch (e) {
      throw Exception('Lỗi thêm phim mới: $e');
    }
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    try {
      // Cập nhật dựa trên ID của phim
      await _firestore.collection('movies').doc(movie.id).update(movie.toJson());
    } catch (e) {
      throw Exception('Lỗi cập nhật phim: $e');
    }
  }

  @override
  Future<bool> deleteMovie(String movieId) async {
    try {
      await _firestore.collection('movies').doc(movieId).delete();
      return true;
    } catch (e) {
      throw Exception('Lỗi xóa phim: $e');
    }
  }
}