// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
  id: json['id'] as String,
  row: json['row'] as String,
  number: (json['number'] as num).toInt(),
  status:
      $enumDecodeNullable(_$SeatStatusEnumMap, json['status']) ??
      SeatStatus.available,
  type:
      $enumDecodeNullable(_$SeatTypeEnumMap, json['type']) ?? SeatType.standard,
);

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
  'id': instance.id,
  'row': instance.row,
  'number': instance.number,
  'status': _$SeatStatusEnumMap[instance.status]!,
  'type': _$SeatTypeEnumMap[instance.type]!,
};

const _$SeatStatusEnumMap = {
  SeatStatus.available: 'available',
  SeatStatus.selected: 'selected',
  SeatStatus.booked: 'booked',
};

const _$SeatTypeEnumMap = {
  SeatType.standard: 'standard',
  SeatType.vip: 'vip',
  SeatType.sweetbox: 'sweetbox',
};
