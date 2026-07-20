import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

@JsonSerializable()
class Ticket extends Equatable {
  final String id;
  final String movieId;
  final List<String> seatIds;
  final double totalPrice;
  final DateTime bookingTime;
  final String qrCodeData;
  final String showtimeId;
  final String roomName;
  final String startTime;

  const Ticket({
    required this.id,
    required this.movieId,
    required this.seatIds,
    required this.totalPrice,
    required this.bookingTime,
    required this.qrCodeData,
    required this.showtimeId,
    required this.roomName,
    required this.startTime,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
  Map<String, dynamic> toJson() => _$TicketToJson(this);

  @override
  List<Object?> get props => [id, movieId, seatIds, totalPrice, bookingTime, qrCodeData, showtimeId, roomName, startTime];
}
