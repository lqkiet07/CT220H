import 'package:flutter/material.dart';
import '../../data/models/ticket.dart';

class BookingProvider extends ChangeNotifier {
  final List<Ticket> _tickets = [];

  List<Ticket> get allTickets => _tickets;

  // Vé sắp chiếu: giờ chiếu trong tương lai
  List<Ticket> get upcomingTickets => _tickets.where((t) {
    final showtime = DateTime.tryParse(t.startTime);
    return showtime != null && showtime.isAfter(DateTime.now());
  }).toList();

  // Vé đã xem: giờ chiếu đã qua
  List<Ticket> get pastTickets => _tickets.where((t) {
    final showtime = DateTime.tryParse(t.startTime);
    return showtime != null && showtime.isBefore(DateTime.now());
  }).toList();

  // Thêm vé mới (gọi sau khi thanh toán thành công)
  void addTicket(Ticket ticket) {
    _tickets.insert(0, ticket); // Vé mới nhất lên đầu
    notifyListeners();
  }
}
