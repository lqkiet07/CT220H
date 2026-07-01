import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie extends Equatable {
  final String id;
  final String title;
  final String posterUrl;
  final double rating;
  final int durationMinutes;
  final double basePrice;
  final List<String> genres; 

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.durationMinutes,
    required this.basePrice,
    this.genres = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  @override
  List<Object?> get props => [id, title, posterUrl, rating, durationMinutes, basePrice, genres];
}
