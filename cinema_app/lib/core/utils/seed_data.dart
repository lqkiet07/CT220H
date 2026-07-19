import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/mock/mock_data.dart'; // Đường dẫn trỏ tới file mock_data.dart của bạn

Future<void> uploadMockDataToFirebase() async {
  final firestore = FirebaseFirestore.instance;

  try {
    debugPrint("🚀 Bắt đầu đưa dữ liệu lên Firebase...");

    // 1. Đẩy Movies
    for (var movie in MockData.getMovies()) {
      await firestore.collection('movies').doc(movie.id).set(movie.toJson());
    }

    // 2. Đẩy Rooms
    for (var room in MockData.getRooms()) {
      await firestore.collection('rooms').doc(room.id).set(room.toJson());
    }

    // 3. Đẩy Showtimes
    for (var showtime in MockData.getShowtimes()) {
      await firestore.collection('showtimes').doc(showtime.id).set(showtime.toJson());
    }

    // 4. Đẩy Users
    for (var user in MockData.getUsers()) {
      await firestore.collection('users').doc(user.id).set(user.toJson());
    }

    // 5. Đẩy Reviews
    for (var review in MockData.getReviews()) {
      await firestore.collection('reviews').doc(review.id).set(review.toJson());
    }

    // 6. Đẩy Seats (Ghế)
    for (var seat in MockData.getSeats()) {
      await firestore.collection('seats').doc(seat.id).set(seat.toJson());
    }

    debugPrint("🎉 HOÀN TẤT BƠM DỮ LIỆU!");
  } catch (e) {
    debugPrint("❌ Lỗi bơm dữ liệu: $e");
  }
}