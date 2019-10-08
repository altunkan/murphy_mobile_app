/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 20:56:48 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-08 21:42:40
 */
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../util/exception/api_error_exception.dart';
import './bloc.dart';
import '../../validators.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../../util/model/api_error.dart';
import '../../constants.dart' as Constants;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final logger = Logger();

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transform(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      LoginRequest loginRequest =
          LoginRequest(email: email, password: password);
      LoginResponse loginResponse = await _login(loginRequest);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(
          "token", "${loginResponse.tokenType} ${loginResponse.accessToken}");
      yield LoginState.success();
    } on ApiErrorException catch (e) {
      logger.e(e);
      yield LoginState.failure(e.apiError);
    }
  }

  Future<LoginResponse> _login(LoginRequest loginRequest) async {
    String url = Constants.loginUrl;
    Map<String, dynamic> loginRequestJson = loginRequest.toJson();
    String loginRequestJsonStr = json.encode(loginRequestJson);
    final response = await http
        .post(url,
            headers: {"Content-Type": "application/json"},
            body: loginRequestJsonStr)
        .timeout(const Duration(seconds: 30));
    Map<String, dynamic> loginResponseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(loginResponseJson);
    } else {
      ApiErrorWrapper apiErrorWrapper = ApiErrorWrapper.fromJson(loginResponseJson);
      throw ApiErrorException(apiError: apiErrorWrapper.apierror);
    }
  }
}
