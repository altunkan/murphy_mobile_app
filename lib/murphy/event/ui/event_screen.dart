/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-16 22:16:53 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-22 17:21:34
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:murphy_mobile_app/murphy/event/model/event_status.dart';

import '../../../authentication/bloc/bloc.dart';
import '../bloc/bloc.dart';
import '../../../authentication/model/user.dart';
import '../../event/model/list_event_response.dart';
import '../../../constants.dart' as Constants;

class EventScreen extends StatelessWidget {
  const EventScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EventList();
  }
}

class EventList extends StatefulWidget {
  EventList({Key key}) : super(key: key);

  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  EventBloc _eventBloc;
  AuthenticationBloc _authenticationBloc;
  User _user;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventLoadingError) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Error"),
                content: new Text(state.apiError.message),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: BlocBuilder<EventBloc, EventState>(builder: (context, state) {
        if (state is EventLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is EventLoaded) {
          return ListView.separated(
            padding: EdgeInsets.all(4.0),
            itemCount: state.hasReachedMax
                ? state.events.length
                : state.events.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index >= state.events.length
                  ? BottomLoader()
                  : _eventCard(state.events[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 0, height: 5);
            },
            controller: _scrollController,
          );
        } else {
          return Center(child: Text(state.toString()));
        }
      }),
    );
  }

  Widget _eventCard(Event event) {
    int murphyPerc = (event.murphy * 10).round();
    DateFormat formatter = DateFormat.yMMMd("en_US");
    ListTile listTile;
    switch (event.status) {
      case EventStatus.NEW:
        listTile = ListTile(
          leading: Icon(FontAwesomeIcons.bomb),
          title:
              Text(event.event, style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(
              event.eventTime != null ? formatter.format(event.eventTime) : ""),
          trailing: Text("$murphyPerc%"),
        );
        break;
      case EventStatus.SUCCESS:
        listTile = ListTile(
          leading: Icon(FontAwesomeIcons.smile, color: Constants.mainColor),
          title: Text(event.event,
              style: TextStyle(
                  color: Constants.mainColor, fontWeight: FontWeight.w700)),
          subtitle: Text(
              event.eventTime != null ? formatter.format(event.eventTime) : ""),
          trailing: Text("$murphyPerc%"),
        );
        break;
      case EventStatus.FAILURE:
        listTile = ListTile(
          leading: Icon(FontAwesomeIcons.sadCry, color: Colors.red),
          title: Text(event.event,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          subtitle: Text(
              event.eventTime != null ? formatter.format(event.eventTime) : ""),
          trailing: Text("$murphyPerc%"),
        );
        break;
    }
    //Color murphyFailed = Colors.
    //Icon icon = FontAwesomeIcons.smile;
    return Slidable(
      child: Card(
        elevation: 2,
        child: listTile,
      ),
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: "Murphied",
          icon: FontAwesomeIcons.sadCry,
          onTap: () {
            _eventBloc.dispatch(UpdateEventStatus(
                event.calculationId.toString(), EventStatus.FAILURE));
          },
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "Not Murphied",
          icon: FontAwesomeIcons.smile,
          onTap: () {
            _eventBloc.dispatch(UpdateEventStatus(
                event.calculationId.toString(), EventStatus.SUCCESS));
          },
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _eventBloc = BlocProvider.of<EventBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    if (_authenticationBloc.currentState is Authenticated) {
      Authenticated authenticated = _authenticationBloc.currentState;
      _user = authenticated.user;
    }

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _eventBloc.dispatch(ListMoreEvent(_user.email));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
