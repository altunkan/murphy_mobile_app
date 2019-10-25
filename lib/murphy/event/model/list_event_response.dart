/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-20 21:19:51 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-22 19:41:21
 */

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'event_status.dart';
import '../../../util/model/page_barrel.dart';

part 'list_event_response.g.dart';

class ListEventResponsePage {
  List<Event> events;
  Page page;

  ListEventResponsePage({@required this.events, @required this.page});

  factory ListEventResponsePage.fromJson(Map<String, dynamic> json) {
    List<Event> events =
        List<Event>.from(json["content"].map((f) => Event.fromJson(f)));
    Page page = Page.fromJson(json);
    return ListEventResponsePage(events: events, page: page);
  }
}

@JsonSerializable()
class Event extends Equatable {
  final int calculationId;
  final String event;
  final double murphy;
  final DateTime eventTime;
  final EventStatus status;

  Event(
      {@required this.calculationId,
      @required this.event,
      @required this.murphy,
      @required this.eventTime,
      @required this.status});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @override
  String toString() {
    return """
      Event {
        calculationId: $calculationId,
        event: $event,
        murphy: $murphy,
        eventTime: $eventTime,
        status: $status
      }
    """;
  }

  @override
  List<Object> get props => [
        this.calculationId,
        this.event,
        this.murphy,
        this.eventTime,
        this.status
      ];
}
