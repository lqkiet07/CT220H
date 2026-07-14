import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_app/main.dart';
// Import interface và model phục vụ tạo class giả lập
import 'package:cinema_app/domain/repositories/movie_repository.dart';
import 'package:cinema_app/data/models/movie.dart';

// 1. Tạo một class giả lập (Fake) không làm gì cả để "lừa" bộ test
class FakeMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> getTrendingMovies() async => [];
  @override
  Future<List<Movie>> getNowPlayingMovies() async => [];
  @override
  Future<List<Movie>> getComingSoonMovies() async => [];
  @override
  Future<Movie> getMovieDetail(String movieId) async => throw UnimplementedError();
  @override
  Future<void> addMovie(Movie movie) async {}
  @override
  Future<void> updateMovie(Movie movie) async {}
  @override
  Future<void> deleteMovie(String movieId) async {}
}

void main() {
  testWidgets('App khởi động thành công và hiển thị Home Page tạm', (WidgetTester tester) async {
    // 2. Khởi tạo repository giả lập
    final fakeRepo = FakeMovieRepository();

    // 3. Truyền fakeRepo vào và xóa chữ "const" trước CinemaApp đi
    await tester.pumpWidget(CinemaApp(movieRepository: fakeRepo));
    await tester.pumpAndSettle();

    expect(find.textContaining('CT220H Cinema'), findsOneWidget);
  });
}