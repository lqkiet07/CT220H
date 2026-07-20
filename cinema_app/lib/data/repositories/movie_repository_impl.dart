import '../../domain/repositories/movie_repository.dart';
import '../models/movie.dart';
import '../remote/api_service.dart';
import '../mock/mock_data.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiService _apiService;

  MovieRepositoryImpl(this._apiService);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    // Simulate network delay and return from MockData
    await Future.delayed(const Duration(seconds: 1));
    return MockData.getMovies();
  }

  @override
  Future<Movie> getMovieDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.getMovies().firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Không tìm thấy phim'),
    );
  }

  @override
  Future<void> addMovie(Movie movie) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.addMovie(movie);
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.updateMovie(movie);
  }

  @override
  Future<void> deleteMovie(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.deleteMovie(id);
  }
}