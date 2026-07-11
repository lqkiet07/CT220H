import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/showtime_repository.dart';
import '../models/showtime.dart'; // Import đúng model Showtime của bạn

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

        // Biến đổi từng chuỗi (VD: "A1") thành đối tượng Seat tương ứng
        return bookedSeats.map((seatStr) {
          return Seat(
            id: seatStr.toString(), // Thay 'id' bằng tên biến đúng trong Model Seat của bạn
            // isBooked: true, // Nếu model Seat của bạn có biến đánh dấu đã đặt
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Lỗi tải danh sách ghế đã đặt: $e');
    }
  }

}