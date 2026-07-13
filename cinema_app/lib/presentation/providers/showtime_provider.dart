import 'package:flutter/material.dart';
import '../../domain/repositories/showtime_repository.dart';
import '../../data/models/showtime.dart';
import '../../data/models/seat.dart';

class ShowtimeProvider with ChangeNotifier {
  final ShowtimeRepository _repository;

  ShowtimeProvider(this._repository) {
    loadAllShowtimes();
  }

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

  Future<void> loadAllShowtimes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _showtimes = await _repository.getAllShowtimes();
      _showtimes.sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
      _isLoading = true;
      notifyListeners();

      await _repository.addShowtime(showtime);
      await loadAllShowtimes();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Cập nhật thông tin suất chiếu và refresh list
  Future<void> updateShowtime(Showtime showtime) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.updateShowtime(showtime);
      await loadAllShowtimes();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Xóa suất chiếu và cập nhật list
  Future<void> deleteShowtime(String showtimeId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.deleteShowtime(showtimeId);
      await loadAllShowtimes();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
