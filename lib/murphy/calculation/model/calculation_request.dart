/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-10 20:48:22 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-10 21:00:39
 */

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calculation_request.g.dart';

@JsonSerializable()
class CalculationRequest {
  String event;
  DateTime eventTime;
  int urgency;
  int importance;
  int complexity;
  int skill;
  int frequency;

  CalculationRequest(
      {@required this.event,
      @required this.eventTime,
      @required this.urgency,
      @required this.importance,
      @required this.complexity,
      @required this.skill,
      @required this.frequency});

  factory CalculationRequest.fromJson(Map<String, dynamic> json) => _$CalculationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CalculationRequestToJson(this);

  @override
  String toString() {
    return """
      CalculationRequest {
        event: $event,
        eventTime: $eventTime,
        urgency: $urgency,
        importance: $importance,
        complexity: $complexity,
        skill: $skill,
        frequency: $frequency
      }
    """;
  }
}
