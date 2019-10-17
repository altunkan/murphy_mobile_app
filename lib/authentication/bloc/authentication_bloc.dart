/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 19:35:56 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-17 18:32:56
 */

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/fetch_util.dart';
import './bloc.dart';
import '../model/user.dart';
import '../../constants.dart' as Constants;
import '../../util/exception/unauthorized_exception.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final logger = Logger();

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.get(Constants.tokenValue);
      if (token == null) {
        yield Unauthenticated();
        return;
      }

      if (token.isEmpty) {
        yield Unauthenticated();
        return;
      }

      logger.d(token);
      User user = await FetchUtil.getUser(token);
      yield Authenticated(user: user);
    } on UnauthorizedException catch (e) {
      logger.e(e);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.get(Constants.tokenValue);
      logger.d(token);
      User user = await FetchUtil.getUser(token);
      yield Authenticated(user: user);
    } on UnauthorizedException catch (e) {
      logger.e(e);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.tokenValue, null);
    yield Unauthenticated();
  }
}
