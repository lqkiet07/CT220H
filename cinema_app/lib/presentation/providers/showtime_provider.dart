import 'package:flutter/material.dart';
import '../../domain/repositories/showtime_repository.dart';
import '../../data/models/showtime.dart';
import '../../data/models/seat.dart';

class ShowtimeProvider with ChangeNotifier {
  final ShowtimeRepository _repository;

  ShowtimeProvider(this._repository);

  // ── State ──────────────────────────────────────────────────────
  List<Showtime> _showtimes = [];
  List<Showtime> get showtimes => _showtimes;

  List<Seat> _bookedSeats = [];
  List<Seat> get bookedSeats => _bookedSeats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── READ ───────────────────────────────────────────────────────

  /// Lấy lịch chiếu theo phim
  Future<void> fetchShowtimes(String movieId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _showtimes = await _repository.getShowtimesByMovie(movieId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy danh sách ghế đã được đặt của suất chiếu
  Future<void> fetchBookedSeats(String showtimeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookedSeats = await _repository.getSeatsByShowtime(showtimeId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── ADMIN CRUD ─────────────────────────────────────────────────

  /// Thêm suất chiếu mới lên Firestore và refresh list
  Future<void> addShowtime(Showtime showtime) async {
    try {
      await _repository.addShowtime(showtime);
      // Refresh list nếu đang xem cùng movieId
      if (_showtimes.isNotEmpty && _showtimes.first.movieId == showtime.movieId) {
        await fetchShowtimes(showtime.movieId);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Cập nhật thông tin suất chiếu và refresh list
  Future<void> updateShowtime(Showtime showtime) async {
    try {
      await _repository.updateShowtime(showtime);
      if (_showtimes.isNotEmpty && _showtimes.first.movieId == showtime.movieId) {
        await fetchShowtimes(showtime.movieId);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Xóa suất chiếu và cập nhật list cục bộ ngay lập tức
  Future<void> deleteShowtime(String showtimeId) async {
    try {
      await _repository.deleteShowtime(showtimeId);
      // Cập nhật UI ngay mà không cần reload từ server
      _showtimes = _showtimes.where((s) => s.id != showtimeId).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}