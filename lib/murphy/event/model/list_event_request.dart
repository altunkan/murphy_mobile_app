/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-20 21:16:44 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-20 21:18:46
 */

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_event_request.g.dart';

@JsonSerializable()
class ListEventRequest {
  String email;

  ListEventRequest({@required this.email});

  factory ListEventRequest.fromJson(Map<String, dynamic> json) =>
      _$ListEventRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ListEventRequestToJson(this);

  @override
  String toString() {
    return """
      ListEventRequest {
        email: $email
      }
    """;
  }
}
