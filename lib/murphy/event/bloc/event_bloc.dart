import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './bloc.dart';
import '../../event/model/list_event_request.dart';
import '../../event/model/list_event_response.dart';
import '../../../util/exception/api_error_exception.dart';
import '../../../util/exception/unauthorized_exception.dart';
import '../../../util/model/api_error.dart';
import '../../../constants.dart' as Constants;
import '../../../util/fetch_util.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final logger = Logger();
  final _sort = "sort=eventTime,desc&sort=calculationId,desc";
  final _size = 10;

  @override
  Stream<EventState> transform(Stream<EventEvent> events,
      Stream<EventState> Function(EventEvent event) next) {
    if (next is ListMoreEvent) {
      return super.transform(
          (events as Observable<EventEvent>)
              .debounceTime(Duration(milliseconds: 3000)),
          next);
    }
    return super.transform(events, next);
  }

  @override
  EventState get initialState => EventLoading();

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is ListEvent) {
      yield* _mapListEventToState(event);
    } else if (event is ListMoreEvent) {
      yield* _mapListMoreEventToState(event);
    } else if (event is UpdateEventStatus) {
      yield* _mapUpdateEventStatusToState(event);
    }
  }

  Stream<EventState> _mapListEventToState(ListEvent listEvent) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get(Constants.tokenValue);
    logger.d(token);
    if (token.isEmpty) {
      throw UnauthorizedException(message: "You are not logged in");
    }

    yield EventLoading();
    //await Future.delayed(Duration(seconds: 3));

    ListEventRequest listEventRequest =
        ListEventRequest(email: listEvent.email);
    try {
      int currentPage = 0;
      ListEventResponsePage listEventResponsePage =
          await FetchUtil.getEventsByEmail(
              token, listEventRequest, currentPage, _size, _sort);
      List<Event> events = listEventResponsePage.events;
      int size = events.length;
      int max = listEventResponsePage.page.totalElements;
      yield EventLoaded(
          events: events,
          currentPage: currentPage,
          hasReachedMax: _checkMax(size, max),
          size: size);
    } on ApiErrorException catch (e) {
      logger.e(e);
      yield EventLoadingError(e.apiError);
    } on UnauthorizedException catch (e) {
      logger.e(e);
      yield EventLoadingError(ApiError.fromMessage(e.message));
    } on Exception catch (e) {
      logger.e(e);
      yield EventLoadingError(ApiError.fromMessage("Unexpected error occured"));
    }
  }

  Stream<EventState> _mapListMoreEventToState(
      ListMoreEvent listMoreEvent) async* {
    ListEventRequest listEventRequest =
        ListEventRequest(email: listMoreEvent.email);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get(Constants.tokenValue);
    logger.d(token);
    if (token.isEmpty) {
      throw UnauthorizedException(message: "You are not logged in");
    }
    try {
      if (!_hasReachedMax(currentState)) {
        EventLoaded eventLoaded = currentState;
        int currentPage = eventLoaded.currentPage;
        int nextPage = currentPage + 1;
        ListEventResponsePage listEventResponsePage =
            await FetchUtil.getEventsByEmail(
                token, listEventRequest, nextPage, _size, _sort);

        List<Event> moreEvents = listEventResponsePage.events;
        List<Event> events = eventLoaded.events + moreEvents;
        int max = listEventResponsePage.page.totalElements;
        int size = events.length;
        yield moreEvents.isEmpty
            ? eventLoaded.copyWith(hasReachedMax: true)
            : EventLoaded(
                events: events,
                hasReachedMax: _checkMax(size, max),
                size: size,
                currentPage: nextPage);
      }
    } on ApiErrorException catch (e) {
      logger.e(e);
      yield EventLoadingError(e.apiError);
    } on UnauthorizedException catch (e) {
      logger.e(e);
      yield EventLoadingError(ApiError.fromMessage(e.message));
    } on Exception catch (e) {
      logger.e(e);
      yield EventLoadingError(ApiError.fromMessage("Unexpected error occured"));
    }
  }

  Stream<EventState> _mapUpdateEventStatusToState(
      UpdateEventStatus updateEventStatus) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get(Constants.tokenValue);
    logger.d(token);
    if (token.isEmpty) {
      throw UnauthorizedException(message: "You are not logged in");
    }

    try {
      if (currentState is EventLoaded) {
        EventLoaded eventLoaded = currentState;
        Event updatedEvent = await FetchUtil.updateEventStatus(token,
            updateEventStatus.calculationId, updateEventStatus.eventStatus);
        int currentPage = eventLoaded.currentPage;
        int size = eventLoaded.size;
        bool hasReachedMax = eventLoaded.hasReachedMax;
        final List<Event> events = List.from(eventLoaded.events.map((event) {
          return event.calculationId == updatedEvent.calculationId
              ? updatedEvent
              : event;
        }).toList());
        logger.d(events == eventLoaded.events);
        EventLoaded eventLoaded2 = EventLoaded(
            events: events,
            currentPage: currentPage,
            hasReachedMax: hasReachedMax,
            size: size);
        logger.d(eventLoaded == eventLoaded2);
        //yield eventLoaded.copyWith(events: events);
        yield eventLoaded2;
      }
    } on ApiErrorException catch (e) {
      logger.e(e);
      yield EventLoadingError(e.apiError);
    } on UnauthorizedException catch (e) {
      logger.e(e);
      yield EventLoadingError(ApiError.fromMessage(e.message));
    } on Exception catch (e) {
      logger.e(e);
      yield EventLoadingError(ApiError.fromMessage("Unexpected error occured"));
    }
  }

  bool _hasReachedMax(EventState state) {
    return state is EventLoaded && state.hasReachedMax;
  }

  bool _checkMax(int size, int max) => size >= max;
}
