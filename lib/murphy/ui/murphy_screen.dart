/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-09 23:03:52 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-16 22:57:55
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:murphy_mobile_app/murphy/event/ui/event_screen.dart';

import '../../authentication/bloc/bloc.dart';
import '../../authentication/model/user.dart';
import '../tab/bloc/bloc.dart';
import '../tab/model/app_tab.dart';
import '../calculation/ui/calculation_screen.dart';

class MurhpyScreen extends StatelessWidget {
  final List<Widget> screens = const [CalculationScreen(), EventScreen()];

  const MurhpyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final TabBloc tabBloc = BlocProvider.of<TabBloc>(context);
    if (authenticationBloc.currentState is Authenticated) {
      //Authenticated authenticated = authenticationBloc.currentState;
      //User user = authenticated.user;
    }

    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Try a Murphy"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  authenticationBloc.dispatch(LoggedOut());
                },
              )
            ],
          ),
          body: IndexedStack(
            index: activeTab.index,
            children: screens,
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) {
              tabBloc.dispatch(UpdateTab(tab));
            },
          ),
        );
      },
    );
  }
}

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  const TabSelector(
      {Key key, @required this.activeTab, @required this.onTabSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: AppTab.values
            .map((tab) => BottomNavigationBarItem(
                icon: Icon(tab == AppTab.calculate ? Icons.event : Icons.list),
                title: Text(tab == AppTab.calculate ? "Calculate" : "Events")))
            .toList(),
        onTap: (index) {
          onTabSelected(AppTab.values[index]);
        },
        currentIndex: AppTab.values.indexOf(activeTab));
  }
}
