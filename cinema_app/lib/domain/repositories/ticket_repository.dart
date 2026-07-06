import '../../data/models/ticket.dart';

abstract class TicketRepository {
  Future<bool> bookTicket(Map<String, dynamic> ticketData);
  Future<List<Ticket>> getTicketHistory();
}