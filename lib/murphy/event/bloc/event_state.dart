import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../model/list_event_response.dart';
import '../../../util/model/api_error.dart';

abstract class EventState extends Equatable {
  EventState([List props = const []]);
}

class EventLoaded extends EventState {
  final List<Event> events;
  final bool hasReachedMax;
  final int currentPage;
  final int size;
  final bool singleEventUpdate;
  final int updatedCalculationId;

  EventLoaded(
      {@required this.events,
      @required this.hasReachedMax,
      @required this.currentPage,
      @required this.size,
      @required this.singleEventUpdate,
      @required this.updatedCalculationId});

  EventLoaded copyWith(
      {List<Event> events,
      bool hasReachedMax,
      int currentPage,
      int size,
      bool singleEventUpdate,
      int updatedCalculationId}) {
    return EventLoaded(
        events: events ?? this.events,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: currentPage ?? this.currentPage,
        size: size ?? this.size,
        singleEventUpdate: singleEventUpdate ?? this.singleEventUpdate,
        updatedCalculationId:
            updatedCalculationId ?? this.updatedCalculationId);
  }

  @override
  String toString() {
    return "EventLoaded {currentPage: $currentPage, size: $size, hasReachedMax: $hasReachedMax updatedCalculationId: $updatedCalculationId}";
  }

  @override
  List<Object> get props => [
        this.events,
        this.hasReachedMax,
        this.currentPage,
        this.size,
        this.singleEventUpdate,
        this.updatedCalculationId
      ];
}

class EventLoading extends EventState {
  @override
  String toString() {
    return "EventLoading";
  }

  @override
  List<Object> get props => null;
}

class EventUpdateLoading extends EventState {
  @override
  String toString() {
    return "EventUpdateLoading";
  }

  @override
  List<Object> get props => null;
}

class EventLoadingError extends EventState {
  final ApiError apiError;

  EventLoadingError(this.apiError);

  @override
  String toString() {
    return "EventLoadingError";
  }

  @override
  List<Object> get props => [this.apiError];
}
