import '../../domain/repositories/movie_repository.dart';
import '../models/movie.dart';
import '../remote/api_service.dart';

class MovieRepositoryImpl implements MovieRepository {
    final ApiService _apiService;

  MovieRepositoryImpl(this._apiService);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      // 1. Gọi API lấy danh sách phim
      final response = await _apiService.getMovies();

      // 2. Kiểm tra xem gọi API có thành công không (Code 200)
      if (response.isSuccessful) {
        // Lấy dữ liệu thô (JSON) từ body của response
        final data = response.body;


        if (data is List) {
          return data.map((json) => Movie.fromJson(json)).toList();
        }

        else if (data is Map && data.containsKey('data')) {
          final List moviesList = data['data'];
          return moviesList.map((json) => Movie.fromJson(json)).toList();
        }

        return []; // Trả về rỗng nếu không khớp cấu trúc
      } else {
        // API trả về lỗi (404, 500...)
        throw Exception('Lỗi Server: Không thể tải danh sách phim. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      // Bắt lỗi mất mạng hoặc sập server
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }

  @override
  Future<Movie> getMovieDetail(String id) async {
    try {
      // 1. Gọi API lấy chi tiết 1 bộ phim theo ID
      final response = await _apiService.getMovieDetail(id);

      // 2. Kiểm tra thành công
      if (response.isSuccessful) {
        final data = response.body;

        // Chuyển đổi JSON thành đối tượng Movie
        return Movie.fromJson(data);
      } else {
        throw Exception('Lỗi Server: Không tìm thấy phim. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }
}