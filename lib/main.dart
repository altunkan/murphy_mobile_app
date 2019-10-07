/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 20:56:45 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-07 22:32:44
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import './authentication/bloc/bloc.dart';
import './splash_screen.dart';
import './simple_bloc_delegate.dart';
import './login/ui/login_screen.dart';
import 'constants.dart' as Constants;

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(BlocProvider(
      builder: (context) => AuthenticationBloc()..dispatch(AppStarted()),
      child: App()));
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
      if (state is Uninitialized) {
        return SplashScreen();
      }
      if (state is Unauthenticated) {
        return LoginScreen();
      }

      return null;
    }), theme: ThemeData(primaryColor: Color(0xFF6C65EA)));
  }
}
