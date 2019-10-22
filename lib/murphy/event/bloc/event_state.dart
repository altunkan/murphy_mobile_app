import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../model/list_event_response.dart';
import '../../../util/model/api_error.dart';

abstract class EventState extends Equatable {
  EventState([List props = const []]) : super(props);
}

class EventLoaded extends EventState {
  List<Event> events;
  bool hasReachedMax;
  int currentPage;
  int size;

  EventLoaded(
      {@required this.events,
      @required this.hasReachedMax,
      @required this.currentPage,
      @required this.size})
      : super([events]);

  EventLoaded copyWith(
      {List<Event> events, bool hasReachedMax, int currentPage, int size}) {
    return EventLoaded(
        events: events ?? this.events,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: currentPage ?? this.currentPage,
        size: size ?? this.size);
  }

  @override
  String toString() {
    return "EventLoaded {currentPage: $currentPage, size: $size, hasReachedMax: $hasReachedMax}";
  }
}

class EventLoading extends EventState {
  @override
  String toString() {
    return "EventLoading";
  }
}

class EventUpdateLoading extends EventState {
  @override
  String toString() {
    return "EventUpdateLoading";
  }
}

class EventLoadingError extends EventState {
  final ApiError apiError;

  EventLoadingError(this.apiError);

  @override
  String toString() {
    return "EventLoadingError";
  }
}
