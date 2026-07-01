import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

enum SeatStatus { available, selected, booked }
enum SeatType { standard, vip, sweetbox }

@JsonSerializable()
class Seat extends Equatable {
  final String id;
  final String row;
  final int number;
  final SeatStatus status;
  final SeatType type;

  const Seat({
    required this.id,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
    this.type = SeatType.standard,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);
  Map<String, dynamic> toJson() => _$SeatToJson(this);

  Seat copyWith({
    String? id,
    String? row,
    int? number,
    SeatStatus? status,
    SeatType? type,
  }) {
    return Seat(
      id: id ?? this.id,
      row: row ?? this.row,
      number: number ?? this.number,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, row, number, status, type];
}
