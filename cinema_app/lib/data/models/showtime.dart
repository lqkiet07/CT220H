import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'showtime.g.dart';

@JsonSerializable()
class Showtime extends Equatable {
  final String id;
  final String movieId;
  final String roomId; 
  final DateTime startTime;
  final double dynamicPricingFactor; 

  const Showtime({
    required this.id,
    required this.movieId,
    required this.roomId,
    required this.startTime,
    this.dynamicPricingFactor = 1.0,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) => _$ShowtimeFromJson(json);
  Map<String, dynamic> toJson() => _$ShowtimeToJson(this);

  @override
  List<Object?> get props => [id, movieId, roomId, startTime, dynamicPricingFactor];
}
