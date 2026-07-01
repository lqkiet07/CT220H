import '../../data/models/movie.dart';

// Đây là Hợp đồng (Interface) cho tính năng Phim
abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<Movie> getMovieDetail(String id);
}
