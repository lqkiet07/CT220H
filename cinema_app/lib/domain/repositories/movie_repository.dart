import '../../data/models/movie.dart';

// Đây là Hợp đồng (Interface) cho tính năng Phim
abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<Movie> getMovieDetail(String id);

  // FIX: Thêm 2 methods bị thiếu trong interface (đã có trong impl)
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getComingSoonMovies();
  
  // Admin Methods
  Future<void> addMovie(Movie movie);
  Future<void> updateMovie(Movie movie);
  Future<bool> deleteMovie(String id);
}
