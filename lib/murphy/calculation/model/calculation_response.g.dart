// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculationResponse _$CalculationResponseFromJson(Map<String, dynamic> json) {
  return CalculationResponse(
    calculationId: json['calculationId'] as int,
    event: json['event'] as String,
    murphy: (json['murphy'] as num)?.toDouble(),
    eventTime: json['eventTime'] == null
        ? null
        : DateTime.parse(json['eventTime'] as String),
  );
}

Map<String, dynamic> _$CalculationResponseToJson(
        CalculationResponse instance) =>
    <String, dynamic>{
      'calculationId': instance.calculationId,
      'event': instance.event,
      'murphy': instance.murphy,
      'eventTime': instance.eventTime?.toIso8601String(),
    };
