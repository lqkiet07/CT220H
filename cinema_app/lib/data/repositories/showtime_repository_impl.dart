import '../../domain/repositories/showtime_repository.dart';
import '../models/showtime.dart';
import '../models/seat.dart';
import '../remote/api_service.dart';
import '../mock/mock_data.dart';

class ShowtimeRepositoryImpl implements ShowtimeRepository {
  final ApiService _apiService;

  ShowtimeRepositoryImpl(this._apiService);

  // ── READ ──────────────────────────────────────────────────────

  @override
  Future<List<Showtime>> getShowtimesByMovie(String movieId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.getShowtimes().where((s) => s.movieId == movieId).toList();
  }

  @override
  Future<List<Seat>> getSeatsByShowtime(String showtimeId) async {
<<<<<<< HEAD
    try {
      final doc =
          await _firestore.collection('showtimes').doc(showtimeId).get();
      if (doc.exists && doc.data() != null) {
        final List<dynamic> bookedSeats =
            List<dynamic>.from(doc.data()!['bookedSeats'] ?? []);

        return bookedSeats.map((seatStr) {
          final String current = seatStr.toString();
          final String row = current.isNotEmpty ? current[0] : '';
          final int number = current.length > 1
              ? (int.tryParse(current.substring(1)) ?? 0)
              : 0;
          return Seat(id: current, row: row, number: number);
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Lỗi tải danh sách ghế đã đặt: $e');
    }
=======
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.getSeats();
>>>>>>> 24ec759 (feat(ui): update booking flow, route guard, QR scanner, deep links, and admin customer management)
  }

  @override
  Future<List<Showtime>> getAllShowtimes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.getShowtimes();
  }

  // ── ADMIN CRUD ────────────────────────────────────────────────

  @override
  Future<void> addShowtime(Showtime showtime) async {
<<<<<<< HEAD
    try {
      final data = showtime.toJson();
      data['startTime'] = Timestamp.fromDate(showtime.startTime);
      data['bookedSeats'] = [];
      data.remove('id');
      await _firestore.collection('showtimes').add(data);
    } catch (e) {
      throw Exception('Lỗi thêm suất chiếu: $e');
    }
=======
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.addShowtime(showtime);
>>>>>>> 24ec759 (feat(ui): update booking flow, route guard, QR scanner, deep links, and admin customer management)
  }

  @override
  Future<void> updateShowtime(Showtime showtime) async {
<<<<<<< HEAD
    try {
      final data = showtime.toJson();
      data['startTime'] = Timestamp.fromDate(showtime.startTime);
      await _firestore
          .collection('showtimes')
          .doc(showtime.id)
          .update(data);
    } catch (e) {
      throw Exception('Lỗi cập nhật suất chiếu: $e');
    }
  }

  @override
  Future<bool> deleteShowtime(String showtimeId) async {
    try {
      await _firestore.collection('showtimes').doc(showtimeId).delete();
      return true;
    } catch (e) {
      throw Exception('Lỗi xóa suất chiếu: $e');
    }
=======
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.updateShowtime(showtime);
  }

  @override
  Future<void> deleteShowtime(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    MockData.deleteShowtime(id);
>>>>>>> 24ec759 (feat(ui): update booking flow, route guard, QR scanner, deep links, and admin customer management)
  }
}