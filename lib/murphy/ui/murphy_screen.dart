/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-09 23:03:52 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-22 20:59:39
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:murphy_mobile_app/murphy/event/ui/event_screen.dart';

import '../../authentication/bloc/bloc.dart';
import '../../authentication/model/user.dart';
import '../tab/bloc/bloc.dart';
import '../tab/model/app_tab.dart';
import '../calculation/ui/calculation_screen.dart';
import '../event/bloc/bloc.dart';
import '../calculation/bloc/bloc.dart';

class MurphyScreen extends StatefulWidget {
  MurphyScreen({Key key}) : super(key: key);

  _MurphyScreenState createState() => _MurphyScreenState();
}

class _MurphyScreenState extends State<MurphyScreen> {
  final List<Widget> _screens = const [CalculationScreen(), EventScreen()];
  AuthenticationBloc _authenticationBloc;
  TabBloc _tabBloc;
  User _user;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _tabBloc = BlocProvider.of<TabBloc>(context);
    _user = (_authenticationBloc.state as Authenticated).user;
  }

  @override
  void dispose() {
    BlocProvider.of<CalculationBloc>(context).close();
    BlocProvider.of<EventBloc>(context).close();
    _tabBloc.close();
    _authenticationBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabBloc, AppTab>(
      listener: (context, state) {
        if (state == AppTab.event) {
          BlocProvider.of<EventBloc>(context).add(ListEvent(_user.email));
        }
      },
      child: BlocBuilder<TabBloc, AppTab>(
        builder: (context, activeTab) {
          return Scaffold(
            appBar: AppBar(
              title: activeTab == AppTab.calculate
                  ? Text("Try a Murphy")
                  : Text("Events"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _authenticationBloc.add(LoggedOut());
                  },
                )
              ],
            ),
            body: IndexedStack(
              index: activeTab.index,
              children: _screens,
            ),
            /*
            body: activeTab == AppTab.calculate
                ? CalculationScreen()
                : EventScreen(),
            */
            bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) {
                _tabBloc.add(UpdateTab(tab));
              },
            ),
          );
        },
      ),
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
