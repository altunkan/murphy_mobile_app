/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 20:03:06 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-03 20:05:48
 */


import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String tokenType;
  String accessToken;

  LoginResponse({@required this.tokenType, @required this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  String toString() {
    return """
      LoginResponse {
        tokenType: $tokenType,
        accessToken: $accessToken
      }
    """;
  }

}

