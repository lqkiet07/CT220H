// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  id: json['id'] as String,
  title: json['title'] as String,
  posterUrl: json['posterUrl'] as String,
  rating: (json['rating'] as num).toDouble(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  basePrice: (json['basePrice'] as num).toDouble(),
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'posterUrl': instance.posterUrl,
  'rating': instance.rating,
  'durationMinutes': instance.durationMinutes,
  'basePrice': instance.basePrice,
  'genres': instance.genres,
};
