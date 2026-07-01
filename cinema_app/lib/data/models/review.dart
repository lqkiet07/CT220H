import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review extends Equatable {
  final String id;
  final String movieId;
  final String userId;
  final double rating;
  final String content;
  final bool hasSpoilers; 

  const Review({
    required this.id,
    required this.movieId,
    required this.userId,
    required this.rating,
    required this.content,
    this.hasSpoilers = false,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  @override
  List<Object?> get props => [id, movieId, userId, rating, content, hasSpoilers];
}
