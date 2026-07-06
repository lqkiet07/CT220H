import '../../data/models/showtime.dart';
import '../../data/models/seat.dart';

abstract class ShowtimeRepository {
  Future<List<Showtime>> getShowtimesByMovie(String movieId);
  Future<List<Seat>> getSeatsByShowtime(String showtimeId);
}