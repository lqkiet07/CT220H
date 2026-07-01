// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  id: json['id'] as String,
  movieId: json['movieId'] as String,
  userId: json['userId'] as String,
  rating: (json['rating'] as num).toDouble(),
  content: json['content'] as String,
  hasSpoilers: json['hasSpoilers'] as bool? ?? false,
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'id': instance.id,
  'movieId': instance.movieId,
  'userId': instance.userId,
  'rating': instance.rating,
  'content': instance.content,
  'hasSpoilers': instance.hasSpoilers,
};
