/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-10 20:48:27 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-10 21:02:25
 */
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../model/calculation_request.dart';

@immutable
abstract class CalculationEvent extends Equatable {
  CalculationEvent([List props = const []]) : super(props);
}

class Calculate extends CalculationEvent {
  final CalculationRequest calculationRequest;

  Calculate(this.calculationRequest);

  @override
  String toString() => "Calculate";
}

class AddCalculation extends CalculationEvent {
  @override
  String toString() => "AddCalculation";
}
