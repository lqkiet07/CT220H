import 'package:drift/drift.dart' as drift;
import '../../domain/repositories/ticket_repository.dart';
import '../models/ticket.dart' as model;
import '../remote/api_service.dart';
import '../local/database.dart';

class TicketRepositoryImpl implements TicketRepository {
  final ApiService _apiService;
  final AppDatabase _appDatabase;

  TicketRepositoryImpl(this._apiService, this._appDatabase);

  @override
  Future<bool> bookTicket(Map<String, dynamic> ticketData) async {
    try {
      final response = await _apiService.bookTicket(ticketData);

      if (response.isSuccessful) {
        final savedData = response.body;

        // Xử lý biến đổi List<String> từ API thành chuỗi String để lưu vào SQLite
        String seatIdsString = '';
        if (savedData['seatIds'] is List) {
          seatIdsString = (savedData['seatIds'] as List).map((e) => e.toString()).join(',');
        } else {
          seatIdsString = savedData['seatIds']?.toString() ?? '';
        }

        // Lưu vào SQLite
        await _appDatabase.insertTicket(
            TicketsCompanion.insert(
              movieId: savedData['movieId']?.toString() ?? '',
              bookingTime: savedData['bookingTime']?.toString() ?? DateTime.now().toIso8601String(),
              qrCodeData: savedData['qrCodeData']?.toString() ?? '',
              seatIds: seatIdsString, // Lưu dạng chuỗi ngăn cách bằng dấu phẩy
              totalPrice: (savedData['totalPrice'] as num?)?.toDouble() ?? 0.0,
            )
        );
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Lỗi quá trình đặt vé: $e');
    }
  }

  @override
  Future<List<model.Ticket>> getTicketHistory() async {
    try {
      final response = await _apiService.getTicketHistory();

      if (response.isSuccessful) {
        final List data = response.body;
        return data.map((json) => model.Ticket.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Khi mất mạng, lấy từ SQLite lên và ÉP KIỂU cho đúng format Model yêu cầu
      final localTickets = await _appDatabase.getAllTickets();

      return localTickets.map((dbTicket) {
        // 1. Ép kiểu String -> DateTime
        final parsedDate = DateTime.tryParse(dbTicket.bookingTime) ?? DateTime.now();

        // 2. Ép kiểu String -> List<String> bằng cách cắt theo dấu phẩy ","
        final parsedSeatIds = dbTicket.seatIds.isEmpty
            ? <String>[]
            : dbTicket.seatIds.split(',');

        return model.Ticket(
          id: dbTicket.id.toString(),
          movieId: dbTicket.movieId,
          bookingTime: parsedDate,       // Đã sửa thành DateTime thành công!
          qrCodeData: dbTicket.qrCodeData,
          seatIds: parsedSeatIds,         // Đã sửa thành List<String> thành công!
          totalPrice: dbTicket.totalPrice,
        );
      }).toList();
    }
  }
}