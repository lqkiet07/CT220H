import '../../domain/repositories/movie_repository.dart';
import '../models/movie.dart';
import '../remote/api_service.dart';
import '../mock/mock_data.dart';

class MovieRepositoryImpl implements MovieRepository {
    final ApiService _apiService;

  MovieRepositoryImpl(this._apiService);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      // Giả lập độ trễ mạng
      await Future.delayed(const Duration(seconds: 1));
      
      // Lấy trực tiếp từ MockData thay vì qua API Chopper để tránh lỗi parser
      return MockData.getMovies();
    } catch (e) {
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