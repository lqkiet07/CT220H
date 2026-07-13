import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/showtime_repository.dart';
import '../models/showtime.dart';
import '../models/seat.dart';

class ShowtimeRepositoryImpl implements ShowtimeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ShowtimeRepositoryImpl();

  // ── READ ──────────────────────────────────────────────────────

  @override
  Future<List<Showtime>> getShowtimesByMovie(String movieId) async {
    try {
      final snapshot = await _firestore
          .collection('showtimes')
          .where('movieId', isEqualTo: movieId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Showtime.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi tải lịch chiếu: $e');
    }
  }

  @override
  Future<List<Seat>> getSeatsByShowtime(String showtimeId) async {
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
  }

  @override
  Future<List<Showtime>> getAllShowtimes() async {
    try {
      final snapshot = await _firestore.collection('showtimes').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Showtime.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi tải tất cả lịch chiếu: $e');
    }
  }

  // ── ADMIN CRUD ────────────────────────────────────────────────

  @override
  Future<void> addShowtime(Showtime showtime) async {
    try {
      final data = showtime.toJson();
      data['startTime'] = Timestamp.fromDate(showtime.startTime);
      data['bookedSeats'] = [];
      data.remove('id');
      await _firestore.collection('showtimes').add(data);
    } catch (e) {
      throw Exception('Lỗi thêm suất chiếu: $e');
    }
  }

  @override
  Future<void> updateShowtime(Showtime showtime) async {
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
  }
}