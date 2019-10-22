/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 20:56:45 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-22 13:58:02
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import './authentication/bloc/bloc.dart';
import './splash_screen.dart';
import './simple_bloc_delegate.dart';
import './login/ui/login_screen.dart';
import './murphy/ui/murphy_screen.dart';
import './murphy/tab/bloc/bloc.dart';
import './murphy/calculation/bloc/bloc.dart';
import './murphy/event/bloc/bloc.dart';

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
    return MaterialApp(
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }

          if (state is Unauthenticated) {
            return LoginScreen();
          }

          if (state is Authenticated) {
            return MultiBlocProvider(providers: [
              BlocProvider<TabBloc>(builder: (context) => TabBloc()),
              BlocProvider<CalculationBloc>(
                  builder: (context) => CalculationBloc()),
              BlocProvider<EventBloc>(builder: (context) => EventBloc())
            ], child: MurphyScreen());
          }

          return null;
        }),
        theme: ThemeData(primaryColor: Color(0xFF6C65EA)));
  }
}

class Test extends StatelessWidget {
  const Test({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("test"),
      ),
    );
  }
}
