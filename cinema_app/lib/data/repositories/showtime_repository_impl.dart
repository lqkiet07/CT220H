import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/showtime_repository.dart';
import '../models/showtime.dart'; // Import đúng model Showtime của bạn
import '../models/seat.dart';
class ShowtimeRepositoryImpl implements ShowtimeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ShowtimeRepositoryImpl();

  @override
  Future<List<Showtime>> getShowtimesByMovie(String movieId) async {
    try {
      // Tìm tất cả các suất chiếu có chứa đúng mã ID của phim này
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

  // Nhớ import model Seat vào đầu file: import '../models/seat.dart';

  @override
  Future<List<Seat>> getSeatsByShowtime(String showtimeId) async {
    try {
      final doc = await _firestore.collection('showtimes').doc(showtimeId).get();
      if (doc.exists && doc.data() != null) {
        final List<dynamic> bookedSeats = doc.data()!['bookedSeats'] ?? [];

        return bookedSeats.map((seatStr) {
          final String currentSeat = seatStr.toString(); // VD: "A5" hoặc "H12"

          // 1. Tách lấy chữ cái đầu làm Hàng (VD: "A5" -> row = "A")
          final String row = currentSeat.isNotEmpty ? currentSeat[0] : '';

          // 2. Tách lấy phần số phía sau làm Số ghế (VD: "A5" -> number = 5)
          // Dùng int.tryParse để ép kiểu an toàn, nếu lỗi thì mặc định là 0
          final int number = currentSeat.length > 1
              ? (int.tryParse(currentSeat.substring(1)) ?? 0)
              : 0;

          return Seat(
            id: currentSeat,
            row: row,
            number: number, // Đã truyền vào biến kiểu int, hết lỗi Type!
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Lỗi tải danh sách ghế đã đặt: $e');
    }
  }

}