import '../../domain/repositories/movie_repository.dart';
import '../models/movie.dart';
import '../remote/api_service.dart';

class MovieRepositoryImpl implements MovieRepository {
  // final ApiService _apiService;
  
  // MovieRepositoryImpl(this._apiService);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    // TODO: (Thành viên A) Gọi _apiService.getMovies() tại đây
    return []; // Trả về list rỗng tạm thời
  }

  @override
  Future<Movie> getMovieDetail(String id) async {
    // TODO: (Thành viên A) Viết logic gọi API lấy chi tiết phim
    throw UnimplementedError("Sẽ code ở Giai đoạn 2");
  }
}
