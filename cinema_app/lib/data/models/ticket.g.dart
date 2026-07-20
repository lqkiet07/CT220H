// GENERATED CODE - DO NOT MODIFY BY HAND
// Đã được chỉnh sửa thủ công để fix lỗi Firestore Timestamp vs DateTime

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value.runtimeType.toString().contains('Timestamp')) {
    return (value as dynamic).toDate() as DateTime;
  }
  if (value is String) return DateTime.parse(value);
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
  bookingTime: _parseDateTime(json['bookingTime']),
  qrCodeData: json['qrCodeData'] as String? ?? json['ticketId'] as String? ?? '',
  showtimeId: json['showtimeId'] as String? ?? '',
  roomName: json['roomName'] as String? ?? '',
  startTime: json['startTime'] as String? ?? '',
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'movieId': instance.movieId,
  'seatIds': instance.seatIds,
  'totalPrice': instance.totalPrice,
  'bookingTime': instance.bookingTime.toIso8601String(),
  'qrCodeData': instance.qrCodeData,
  'showtimeId': instance.showtimeId,
  'roomName': instance.roomName,
  'startTime': instance.startTime,
};
