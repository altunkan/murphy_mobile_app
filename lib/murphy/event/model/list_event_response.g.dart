// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    calculationId: json['calculationId'] as int,
    event: json['event'] as String,
    murphy: (json['murphy'] as num)?.toDouble(),
    eventTime: json['eventTime'] == null
        ? null
        : DateTime.parse(json['eventTime'] as String),
    status: _$enumDecodeNullable(_$EventStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'calculationId': instance.calculationId,
      'event': instance.event,
      'murphy': instance.murphy,
      'eventTime': instance.eventTime?.toIso8601String(),
      'status': _$EventStatusEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EventStatusEnumMap = {
  EventStatus.NEW: 'NEW',
  EventStatus.SUCCESS: 'SUCCESS',
  EventStatus.FAILURE: 'FAILURE',
};
