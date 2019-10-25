/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-10 22:20:15 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-22 20:43:01
 */
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';
import '../model/calculation_request.dart';
import '../model/calculation_response.dart';
import '../../../util/exception/api_error_exception.dart';
import '../../../util/exception/unauthorized_exception.dart';
import '../../../util/model/api_error.dart';
import '../../../constants.dart' as Constants;
import '../../../util/fetch_util.dart';

class CalculationBloc extends Bloc<CalculationEvent, CalculationState> {
  final logger = Logger();

  @override
  CalculationState get initialState => CalculationNew();

  @override
  Stream<CalculationState> mapEventToState(CalculationEvent event) async* {
    if (event is Calculate) {
      yield* _mapCalculateToState(event);
    } else if (event is AddCalculation) {
      yield* _mapAddCalculationToState();
    }
  }

  Stream<CalculationState> _mapAddCalculationToState() async* {
    yield CalculationLoading();
    yield CalculationNew();
  }

  Stream<CalculationState> _mapCalculateToState(Calculate event) async* {
    yield CalculationLoading();
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.get(Constants.tokenValue);
      logger.d(token);
      if (token.isEmpty) {
        throw UnauthorizedException(message: "You are not logged in");
      }
      CalculationRequest calculationRequest = event.calculationRequest;
      CalculationResponse calculationResponse =
          await FetchUtil.calculate(token, calculationRequest);
      yield CalculationProcessed(calculationResponse);
    } on ApiErrorException catch (e) {
      logger.e(e);
      yield CalculationError(e.apiError);
    } on UnauthorizedException catch (e) {
      logger.e(e);
      yield CalculationError(ApiError.fromMessage(e.message));
    } on Exception catch (e) {
      logger.e(e);
      yield CalculationError(ApiError.fromMessage("Unexpected error occured"));
    }
  }
}
