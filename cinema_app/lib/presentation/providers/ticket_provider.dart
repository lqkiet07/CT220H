import 'package:flutter/material.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../../data/models/ticket.dart';
import '../../data/models/seat.dart';

class TicketProvider with ChangeNotifier {
  final TicketRepository _repository;

  TicketProvider(this._repository);

  List<Ticket> _myTickets = [];
  List<Ticket> get myTickets => _myTickets;

  final List<Seat> _selectedSeats = [];
  List<Seat> get selectedSeats => _selectedSeats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Xử lý logic khi người dùng bấm vào một ghế trên màn hình
  void toggleSeatSelection(Seat seat) {
    if (_selectedSeats.any((s) => s.id == seat.id)) {
      _selectedSeats.removeWhere((s) => s.id == seat.id); // Bỏ chọn
    } else {
      _selectedSeats.add(seat); // Chọn ghế
    }
    notifyListeners();
  }

  // Xóa danh sách ghế đang chọn (dùng khi thoát màn hình hoặc đặt vé xong)
  void clearSelectedSeats() {
    _selectedSeats.clear();
    notifyListeners();
  }

  // Thực hiện đặt vé lên Firebase
  Future<bool> bookTicket({
    required String showtimeId,
    required String userId,
    required double totalPrice,
  }) async {
    if (_selectedSeats.isEmpty) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Lấy ra danh sách các mã ghế (VD: ["A1", "A2"])
      final seatIds = _selectedSeats.map((s) => s.id).toList();

      // FIX: Gói dữ liệu vào Map<String, dynamic> đúng với signature của Interface
      await _repository.bookTicket({
        'showtimeId': showtimeId,
        'seats': seatIds,
        'uid': userId,
        'totalPrice': totalPrice,
      });

      clearSelectedSeats(); // Đặt thành công thì xóa giỏ hàng
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy danh sách vé của tôi để hiển thị ở trang Profile/Lịch sử
  // FIX: Đổi từ getTicketsByUser(userId) → getTicketHistory() đúng tên hàm trong Interface
  Future<void> fetchMyTickets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myTickets = await _repository.getTicketHistory();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}