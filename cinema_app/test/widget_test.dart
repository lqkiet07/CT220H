import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_app/main.dart';
// Import interface và model phục vụ tạo class giả lập
import 'package:cinema_app/domain/repositories/movie_repository.dart';
import 'package:cinema_app/domain/repositories/user_repository.dart';
import 'package:cinema_app/domain/repositories/showtime_repository.dart';
import 'package:cinema_app/domain/repositories/ticket_repository.dart';
import 'package:cinema_app/data/models/movie.dart';
import 'package:cinema_app/data/models/user.dart' as app_user;
import 'package:cinema_app/data/models/showtime.dart';
import 'package:cinema_app/data/models/seat.dart';
import 'package:cinema_app/data/models/ticket.dart';

// 1. Tạo class giả lập FakeMovieRepository
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
  // FIX: deleteMovie trả về Future<bool> theo interface (không phải void)
  @override
  Future<bool> deleteMovie(String movieId) async => true;
}

// 2. Fake UserRepository
class FakeUserRepository implements UserRepository {
  @override
  Future<bool> login(String email, String password) async => true;
  @override
  Future<bool> register(Map<String, dynamic> userData) async => true;
  @override
  Future<app_user.User> getProfile() async => throw UnimplementedError();
}

// 3. Fake ShowtimeRepository
class FakeShowtimeRepository implements ShowtimeRepository {
  @override
  Future<List<Showtime>> getShowtimesByMovie(String movieId) async => [];
  @override
  Future<List<Seat>> getSeatsByShowtime(String showtimeId) async => [];
  
  @override
  Future<void> addShowtime(Showtime showtime) async {}
  @override
  Future<void> updateShowtime(Showtime showtime) async {}
  @override
  Future<bool> deleteShowtime(String showtimeId) async => true;
}

// 4. Fake TicketRepository
class FakeTicketRepository implements TicketRepository {
  @override
  Future<bool> bookTicket(Map<String, dynamic> ticketData) async => true;
  @override
  Future<List<Ticket>> getTicketHistory() async => [];
}

void main() {
  testWidgets('App khởi động thành công và hiển thị Home Page', (WidgetTester tester) async {
    // FIX: Truyền đủ 4 repository theo constructor của CinemaApp
    await tester.pumpWidget(CinemaApp(
      movieRepository: FakeMovieRepository(),
      userRepository: FakeUserRepository(),
      showtimeRepository: FakeShowtimeRepository(),
      ticketRepository: FakeTicketRepository(),
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('CT220H Cinema'), findsOneWidget);
  });
}