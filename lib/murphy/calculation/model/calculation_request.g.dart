// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculationRequest _$CalculationRequestFromJson(Map<String, dynamic> json) {
  return CalculationRequest(
    event: json['event'] as String,
    eventTime: json['eventTime'] == null
        ? null
        : DateTime.parse(json['eventTime'] as String),
    urgency: json['urgency'] as int,
    importance: json['importance'] as int,
    complexity: json['complexity'] as int,
    skill: json['skill'] as int,
    frequency: json['frequency'] as int,
  );
}

Map<String, dynamic> _$CalculationRequestToJson(CalculationRequest instance) =>
    <String, dynamic>{
      'event': instance.event,
      'eventTime': instance.eventTime?.toIso8601String(),
      'urgency': instance.urgency,
      'importance': instance.importance,
      'complexity': instance.complexity,
      'skill': instance.skill,
      'frequency': instance.frequency,
    };
