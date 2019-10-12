/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-10 20:58:01 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-10 21:01:31
 */

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calculation_response.g.dart';

@JsonSerializable()
class CalculationResponse extends Equatable {
  int calculationId;
  String event;
  double murphy;
  DateTime eventTime;

  CalculationResponse(
      {@required this.calculationId, @required this.event, @required this.murphy, @required this.eventTime})
      : super([calculationId]);

  factory CalculationResponse.fromJson(Map<String, dynamic> json) => _$CalculationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CalculationResponseToJson(this);

  @override
  String toString() {
    return """
      CalculationResponse {
        calculationId: $calculationId,
        event: $event,
        murphy: $murphy,
        eventTime: $eventTime
      }
    """;
  }
}
