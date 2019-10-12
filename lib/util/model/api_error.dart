/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-07 23:14:42 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-09 22:55:55
 */

import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiErrorWrapper {
  ApiError apierror;

  ApiErrorWrapper({this.apierror});

  factory ApiErrorWrapper.fromJson(Map<String, dynamic> json) => _$ApiErrorWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorWrapperToJson(this);
  
}

@JsonSerializable()
class ApiError {
  String status;
  DateTime timestamp;
  String message;

  ApiError({this.status, this.timestamp, this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);
  factory ApiError.fromMessage(String message) => ApiError(status: "UNEXPECTED_ERROR", timestamp: DateTime.now(), message: message);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}