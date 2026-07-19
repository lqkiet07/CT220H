// GENERATED CODE - DO NOT MODIFY BY HAND
// Đã được chỉnh sửa thủ công để fix lỗi Firestore Timestamp vs DateTime

part of 'showtime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

/// Helper: chuyển đổi an toàn từ Firestore Timestamp, String ISO, hoặc int (milliseconds)
/// sang DateTime. Tránh crash khi field 'startTime' được lưu dưới dạng Timestamp.
DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  // Firestore Timestamp object có method .toDate()
  if (value.runtimeType.toString().contains('Timestamp')) {
    return (value as dynamic).toDate() as DateTime;
  }
  // Chuỗi ISO 8601
  if (value is String) return DateTime.parse(value);
  // Milliseconds dưới dạng int
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.now();
}

Showtime _$ShowtimeFromJson(Map<String, dynamic> json) => Showtime(
  id: json['id'] as String,
  movieId: json['movieId'] as String,
  roomId: json['roomId'] as String,
  // FIX: Dùng _parseDateTime thay vì DateTime.parse để handle Firestore Timestamp
  startTime: _parseDateTime(json['startTime']),
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
