import 'package:equatable/equatable.dart';

import '../model/event_status.dart';

abstract class EventEvent extends Equatable {
  EventEvent([List props = const []]);
}

class ListEvent extends EventEvent {
  final String email;

  ListEvent(this.email);

  @override
  String toString() {
    return "ListEvent";
  }

  @override
  List<Object> get props => [this.email];
}

class ListMoreEvent extends EventEvent {
  final String email;

  ListMoreEvent(this.email);

  @override
  String toString() {
    return "ListMoreEvent";
  }

  @override
  List<Object> get props => [this.email];
}

class UpdateEventStatus extends EventEvent {
  final int calculationId;
  final EventStatus eventStatus;

  UpdateEventStatus(this.calculationId, this.eventStatus);

  @override
  String toString() {
    return "UpdateEventStatus{calculationId: $calculationId, eventStatus: $eventStatus}";
  }

  @override
  List<Object> get props => [this.calculationId, this.eventStatus];
}
