/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-07 23:14:42 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-07 23:18:37
 */

import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiErrorWrapper {
  ApiError apierror;

  ApiErrorWrapper({this.apierror});
  factory ApiErrorWrapper.fromJson(Map<String, dynamic> json) => _$ApiErrorWrapperFromJson(json);
}

@JsonSerializable()
class ApiError {
  String status;
  DateTime timestamp;
  String message;

  ApiError({this.status, this.timestamp, this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);
}