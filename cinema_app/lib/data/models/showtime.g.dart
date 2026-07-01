// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Showtime _$ShowtimeFromJson(Map<String, dynamic> json) => Showtime(
  id: json['id'] as String,
  movieId: json['movieId'] as String,
  roomId: json['roomId'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  dynamicPricingFactor:
      (json['dynamicPricingFactor'] as num?)?.toDouble() ?? 1.0,
);

Map<String, dynamic> _$ShowtimeToJson(Showtime instance) => <String, dynamic>{
  'id': instance.id,
  'movieId': instance.movieId,
  'roomId': instance.roomId,
  'startTime': instance.startTime.toIso8601String(),
  'dynamicPricingFactor': instance.dynamicPricingFactor,
};
