import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../models/ticket.dart';

class TicketRepositoryImpl implements TicketRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TicketRepositoryImpl();

  // Đã sửa tham số thành Map<String, dynamic> theo đúng Interface
  @override
  Future<bool> bookTicket(Map<String, dynamic> ticketData) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception('Bạn cần đăng nhập để đặt vé!');

      final showtimeId = ticketData['showtimeId'] as String;
      final selectedSeats = List<String>.from(ticketData['seats'] ?? []);
      final totalPrice = ticketData['totalPrice'] as double;

      await _firestore.runTransaction((transaction) async {
        final showtimeRef = _firestore.collection('showtimes').doc(showtimeId);
        final showtimeSnapshot = await transaction.get(showtimeRef);

        if (!showtimeSnapshot.exists) throw Exception('Suất chiếu không tồn tại!');

        final List<dynamic> currentBookedSeats = showtimeSnapshot.data()?['bookedSeats'] ?? [];
        for (var seat in selectedSeats) {
          if (currentBookedSeats.contains(seat)) {
            throw Exception('Ghế $seat đã có người đặt!');
          }
        }

        currentBookedSeats.addAll(selectedSeats);
        transaction.update(showtimeRef, {'bookedSeats': currentBookedSeats});

        final ticketRef = _firestore.collection('tickets').doc();
        transaction.set(ticketRef, {
          'ticketId': ticketRef.id,
          'uid': uid,
          'showtimeId': showtimeId,
          'seats': selectedSeats,
          'totalPrice': totalPrice,
          'bookingTime': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      throw Exception('Đặt vé thất bại: $e');
    }
  }

  // Đã đổi tên hàm thành getTicketHistory
  @override
  Future<List<Ticket>> getTicketHistory() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception('Chưa đăng nhập');

      final snapshot = await _firestore
          .collection('tickets')
          .where('uid', isEqualTo: uid)
          .orderBy('bookingTime', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Ticket.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi tải lịch sử đặt vé: $e');
    }
  }
}