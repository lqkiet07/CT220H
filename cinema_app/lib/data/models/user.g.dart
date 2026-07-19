// GENERATED CODE - DO NOT MODIFY BY HAND
// Đã được chỉnh sửa thủ công để fix mismatch field name giữa Firestore và Model

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String? ?? json['uid'] as String? ?? '',
  name: json['name'] as String? ?? json['fullName'] as String? ?? '',
  email: json['email'] as String? ?? '',
  favoriteMovieIds:
      (json['favoriteMovieIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'favoriteMovieIds': instance.favoriteMovieIds,
};
