import 'package:equatable/equatable.dart';

import '../model/event_status.dart';

abstract class EventEvent extends Equatable {
  EventEvent([List props = const []]) : super(props);
}

class ListEvent extends EventEvent {
  final String email;

  ListEvent(this.email);

  @override
  String toString() {
    return "ListEvent";
  }
}

class ListMoreEvent extends EventEvent {
  final String email;

  ListMoreEvent(this.email);

  @override
  String toString() {
    return "ListMoreEvent";
  }
}

class UpdateEventStatus extends EventEvent {
  final String calculationId;
  final EventStatus eventStatus;

  UpdateEventStatus(this.calculationId, this.eventStatus);

  @override
  String toString() {
    return "UpdateEventStatus{calculationId: $calculationId, eventStatus: $eventStatus}";
  }
}
