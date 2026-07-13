import '../../data/models/showtime.dart';
import '../../data/models/seat.dart';

abstract class ShowtimeRepository {
  // ── READ ──────────────────────────────────────────────────────
  Future<List<Showtime>> getShowtimesByMovie(String movieId);
  Future<List<Showtime>> getAllShowtimes();
  Future<List<Seat>> getSeatsByShowtime(String showtimeId);

  // ── ADMIN CRUD ────────────────────────────────────────────────
  Future<void> addShowtime(Showtime showtime);
  Future<void> updateShowtime(Showtime showtime);
  Future<bool> deleteShowtime(String showtimeId);
}