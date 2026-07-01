// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  id: json['id'] as String,
  movieId: json['movieId'] as String,
  seatIds: (json['seatIds'] as List<dynamic>).map((e) => e as String).toList(),
  totalPrice: (json['totalPrice'] as num).toDouble(),
  bookingTime: DateTime.parse(json['bookingTime'] as String),
  qrCodeData: json['qrCodeData'] as String,
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'movieId': instance.movieId,
  'seatIds': instance.seatIds,
  'totalPrice': instance.totalPrice,
  'bookingTime': instance.bookingTime.toIso8601String(),
  'qrCodeData': instance.qrCodeData,
};
