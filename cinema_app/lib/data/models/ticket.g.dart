// GENERATED CODE - DO NOT MODIFY BY HAND
// Đã được chỉnh sửa thủ công để fix lỗi Firestore Timestamp vs DateTime

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

/// Helper: chuyển đổi an toàn từ Firestore Timestamp, String ISO, hoặc int
/// sang DateTime. Tránh crash khi 'bookingTime' dùng FieldValue.serverTimestamp().
DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  // Firestore Timestamp object có method .toDate()
  if (value.runtimeType.toString().contains('Timestamp')) {
    return (value as dynamic).toDate() as DateTime;
  }
  // Chuỗi ISO 8601
  if (value is String) return DateTime.parse(value);
  // Milliseconds dưới dạng int
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.now();
}

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  id: json['id'] as String,
  movieId: json['movieId'] as String? ?? json['showtimeId'] as String? ?? '',
  seatIds: (json['seats'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      (json['seatIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  totalPrice: (json['totalPrice'] as num).toDouble(),
  // FIX: Dùng _parseDateTime thay vì DateTime.parse để handle Firestore Timestamp
  bookingTime: _parseDateTime(json['bookingTime']),
  qrCodeData: json['qrCodeData'] as String? ?? json['ticketId'] as String? ?? '',
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'movieId': instance.movieId,
  'seatIds': instance.seatIds,
  'totalPrice': instance.totalPrice,
  'bookingTime': instance.bookingTime.toIso8601String(),
  'qrCodeData': instance.qrCodeData,
};
