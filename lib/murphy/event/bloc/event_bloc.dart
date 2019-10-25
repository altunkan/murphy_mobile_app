import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Stream<EventState> transformEvents(
    Stream<EventEvent> events,
    Stream<EventState> Function(EventEvent event) next,
  ) {
    final observableStream = events as Observable<EventEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! ListMoreEvent);
    });
    final debounceStream = observableStream.where((event) {
      return (event is ListMoreEvent);
    }).debounceTime(Duration(milliseconds: 500));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
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
          size: size,
          singleEventUpdate: false,
          updatedCalculationId: null);
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
      if (!_hasReachedMax(state)) {
        EventLoaded eventLoaded = state;
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
                currentPage: nextPage,
                singleEventUpdate: false,
                updatedCalculationId: null);
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
      if (state is EventLoaded) {
        EventLoaded eventLoaded = state;
        int updatedCalculationId = updateEventStatus.calculationId;
        yield eventLoaded.copyWith(
            singleEventUpdate: true,
            updatedCalculationId: updatedCalculationId);
        await Future.delayed(Duration(seconds: 1));
        Event updatedEvent = await FetchUtil.updateEventStatus(
            token, updatedCalculationId, updateEventStatus.eventStatus);
        final List<Event> events = List.from(eventLoaded.events.map((event) {
          return event.calculationId == updatedEvent.calculationId
              ? updatedEvent
              : event;
        }).toList());

        yield eventLoaded.copyWith(
            events: events,
            singleEventUpdate: false,
            updatedCalculationId: null);
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
