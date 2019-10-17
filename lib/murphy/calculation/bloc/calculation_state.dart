/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-10 20:48:30 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-16 23:49:48
 */
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../model/calculation_response.dart';
import '../../../util/model/api_error.dart';

@immutable
abstract class CalculationState extends Equatable {
  CalculationState([List props = const []]) : super(props);
}

class CalculationNew extends CalculationState {
  /*
  final bool isEventValid;
  final bool isEventDateValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  CalculationNew(
      {@required this.isEventValid,
      @required this.isEventDateValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  bool get isFormValid => isEventValid && isEventDateValid;

  factory CalculationNew.empty() {
    return CalculationNew(
        isEventValid: true,
        isEventDateValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  factory CalculationNew.failure() {
    return CalculationNew(
        isEventValid: true,
        isEventDateValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  factory CalculationNew.success() {
    return CalculationNew(
        isEventValid: true,
        isEventDateValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  CalculationNew update({
    bool isEventValid,
    bool isEventDateValid,
  }) {
    return copyWith(
      isEventValid: isEventValid,
      isEventDateValid: isEventDateValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  CalculationNew copyWith({
    bool isEventValid,
    bool isEventDateValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return CalculationNew(
      isEventValid: isEventValid ?? this.isEventValid,
      isEventDateValid: isEventDateValid ?? this.isEventDateValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
  */
  @override
  String toString() => "CalculationNew";
}

class CalculationLoading extends CalculationState {
  @override
  String toString() => "CalculationLoading";
}

class CalculationProcessed extends CalculationState {
  final CalculationResponse calculationResponse;

  CalculationProcessed(this.calculationResponse) : super([calculationResponse]);

  @override
  String toString() => "CalculationProcessed";
}

class CalculationError extends CalculationState {
  final ApiError apiError;

  CalculationError(this.apiError);

  @override
  String toString() => "CalculationError";
}
