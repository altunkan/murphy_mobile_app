/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-12 13:42:25 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-17 18:36:37
 */

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../login/model/login_request.dart';
import '../login/model/login_response.dart';
import './model/api_error.dart';
import '../constants.dart' as Constants;
import './exception/api_error_exception.dart';
import '../authentication/model/user.dart';
import './exception/unauthorized_exception.dart';
import '../signup/model/signup_request.dart';
import '../signup/model/signup_response.dart';
import '../murphy/calculation/model/calculation_request.dart';
import '../murphy/calculation/model/calculation_response.dart';

class FetchUtil {
  static final logger = Logger();

  static Future<LoginResponse> login(LoginRequest loginRequest) async {
    String url = Constants.loginUrl;
    Map<String, dynamic> loginRequestJson = loginRequest.toJson();
    String loginRequestJsonStr = json.encode(loginRequestJson);
    final response = await http
        .post(url,
            headers: {"Content-Type": "application/json"},
            body: loginRequestJsonStr)
        .timeout(const Duration(seconds: 10));
    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic> loginResponseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(loginResponseJson);
    } else {
      ApiErrorWrapper apiErrorWrapper =
          ApiErrorWrapper.fromJson(loginResponseJson);
      throw ApiErrorException(apiError: apiErrorWrapper.apierror);
    }
  }

  static Future<SignupResponse> signup(SignupRequest signupRequest) async {
    String url = Constants.signupUrl;
    Map<String, dynamic> signupRequestJson = signupRequest.toJson();
    String signupRequestJsonStr = json.encode(signupRequestJson);
    final response = await http
        .post(url,
            headers: {"Content-Type": "application/json"},
            body: signupRequestJsonStr)
        .timeout(const Duration(seconds: 30));
    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic> signupResponseJson = json.decode(response.body);
    if (response.statusCode == 201) {
      return SignupResponse.fromJson(signupResponseJson);
    } else {
      ApiErrorWrapper apiErrorWrapper =
          ApiErrorWrapper.fromJson(signupResponseJson);
      throw ApiErrorException(apiError: apiErrorWrapper.apierror);
    }
  }

  static Future<User> getUser(String token) async {
    String url = Constants.userUrl;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      Constants.tokenName: "$token"
    };
    final response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      Map<String, dynamic> userResponseJson = json.decode(response.body);
      return User.fromJson(userResponseJson);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(message: "You are not logged in");
    } else {
      logger.d(json.decode(response.body));
      throw Exception();
    }
  }

  static Future<CalculationResponse> calculate(
      String token, CalculationRequest calculationRequest) async {
    String url = Constants.calculateUrl;
    Map<String, dynamic> calculationRequestJson = calculationRequest.toJson();
    String calculationRequestJsonStr = json.encode(calculationRequestJson);
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      Constants.tokenName: "$token"
    };
    final response = await http
        .post(url, headers: requestHeaders, body: calculationRequestJsonStr)
        .timeout(const Duration(seconds: 30));
    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic> calculationResponseJson = json.decode(response.body);
    if (response.statusCode == 201) {
      Map<String, String> responseHeaders = response.headers;
      String location = responseHeaders["Location"];
      logger.d(location);
      return CalculationResponse.fromJson(calculationResponseJson);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(message: "You are not logged in");
    } else {
      ApiErrorWrapper apiErrorWrapper =
          ApiErrorWrapper.fromJson(calculationResponseJson);
      throw ApiErrorException(apiError: apiErrorWrapper.apierror);
    }
  }
}
