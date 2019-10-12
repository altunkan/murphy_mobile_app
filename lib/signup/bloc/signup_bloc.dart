/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-07 21:27:06 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-12 18:01:23
 */
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';
import '../../validators.dart';
import '../model/signup_request.dart';
import '../model/signup_response.dart';
import '../../util/exception/api_error_exception.dart';
import '../../util/model/api_error.dart';
import '../../util/fetch_util.dart';
import '../../constants.dart' as Constants;
import '../../login/model/login_request.dart';
import '../../login/model/login_response.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final logger = Logger();

  @override
  SignupState get initialState => SignupState.empty();

  @override
  Stream<SignupState> transform(
    Stream<SignupEvent> events,
    Stream<SignupState> Function(SignupEvent event) next,
  ) {
    final observableStream = events as Observable<SignupEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged && event is! RetypePasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged || event is RetypePasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password, event.retypePassword);
    } else if (event is RetypePasswordChanged) {
      yield* _mapPasswordChangedToState(event.password, event.retypePassword);
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignupState> _mapPasswordChangedToState(String password, String retypePassword) async* {
    yield currentState.update(
        isPasswordValid: password.isNotEmpty && retypePassword.isNotEmpty ? password == retypePassword : true);
  }

  Stream<SignupState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignupState.loading();
    try {
      SignupRequest signupRequest = SignupRequest(email: email, name: email, password: password);
      SignupResponse signupResponse = await FetchUtil.signup(signupRequest);

      LoginRequest loginRequest = LoginRequest(email: email, password: password);
      LoginResponse loginResponse = await FetchUtil.login(loginRequest);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(Constants.tokenValue, "${loginResponse.tokenType} ${loginResponse.accessToken}");
      logger.d(signupResponse);
      yield SignupState.success();
    } on ApiErrorException catch (e) {
      logger.e(e);
      yield SignupState.failure(e.apiError);
    } on Exception catch (e) {
      logger.e(e);
      yield SignupState.failure(ApiError.fromMessage("Unexpected error occured"));
    }
  }
}
