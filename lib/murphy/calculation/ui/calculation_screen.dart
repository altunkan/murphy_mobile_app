/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-10 22:21:22 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-12 23:07:51
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:murphy_mobile_app/murphy/calculation/model/calculation_request.dart';

import '../../calculation/bloc/bloc.dart';
import '../../../constants.dart' as Constants;
import '../model/calculation_response.dart';

class CalculationScreen extends StatelessWidget {
  const CalculationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    return BlocProvider(
      builder: (context) => CalculationBloc(),
      child: CalculationForm(),
    );
    */
    return CalculationForm();
  }
}

class CalculationForm extends StatefulWidget {
  CalculationForm({Key key}) : super(key: key);

  _CalculationFormState createState() => _CalculationFormState();
}

class _CalculationFormState extends State<CalculationForm> {
  final Logger logger = Logger();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  CalculationBloc _calculationBloc;
  DateTime _eventDate;
  double _urgency = 1;
  double _importance = 1;
  double _complexity = 1;
  double _skill = 1;
  double _frequencey = 1;

  bool get isPopulated =>
      _eventNameController.text.isNotEmpty &&
      _eventDateController.text.isNotEmpty;
  bool isCalculateButtonEnabled() => isPopulated;

  Future<Null> _getEventDate() async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = initialDate;
    DateTime lastDate =
        DateTime(initialDate.year + 1, initialDate.month, initialDate.day);
    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);
    DateFormat formatter = DateFormat.yMMMd("en_US");
    String selectedDateStr = formatter.format(selectedDate);
    _eventDate = selectedDate;
    setState(() {
      _eventDateController.text = selectedDateStr;
    });
  }

  Future<Null> _displayParameterInfo(String parameter) async {
    String title;
    String question;
    String description;

    switch (parameter) {
      case "urgency":
        {
          title = "Urgency";
          question = "How urgent is this task?";
          description = "1 = sometime this year, maybe, 9 = right away";
        }
        break;
      case "importance":
        {
          title = "Importance";
          question = "How important is this task?";
          description = "1 = complete waste of time, 9 = absolutely critical";
        }
        break;
      case "complexity":
        {
          title = "Complexity";
          question = "How complex is this task?";
          description = "1 = a child could do it, 9 = brain surgery";
        }
        break;
      case "skill":
        {
          title = "Skill";
          question = "What is your skill level for this?";
          description = "1 = complete klutz, 9 = expert";
        }
        break;
      case "frequency":
        {
          title = "Frequency";
          question = "How often do you have to do this?";
          description = "1 = just once, 9 = every day";
        }
        break;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //title: new Text(title, style: TextStyle(color: Constants.mainColor)),
          contentPadding: const EdgeInsets.all(10),
          children: <Widget>[
            SizedBox(height: 4),
            ListTile(
              title: Text(question),
              subtitle: Text(description),
            ),
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _calculationBloc = BlocProvider.of<CalculationBloc>(context);
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalculationBloc, CalculationState>(
      listener: (context, state) {
        if (state is CalculationError) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
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
      child: BlocBuilder<CalculationBloc, CalculationState>(
        builder: (context, state) {
          if (state is CalculationNew || state is CalculationError) {
            return Form(
              child: ListView(
                padding: const EdgeInsets.all(12.0),
                children: <Widget>[
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.4,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Event",
                          labelStyle: Constants.loginUiLabelStyle,
                          suffixIcon: Icon(Icons.note, size: 18),
                        ),
                        keyboardType: TextInputType.text,
                        controller: _eventNameController,
                      ),
                      GestureDetector(
                        onTap: () {
                          _getEventDate();
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                              enabled: true,
                              enableInteractiveSelection: false,
                              controller: _eventDateController,
                              decoration: InputDecoration(
                                labelText: "Event Date",
                                labelStyle: Constants.loginUiLabelStyle,
                                suffixIcon: Icon(Icons.date_range, size: 18),
                              )),
                        ),
                      )
                    ],
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Urgency (${_urgency.round()})",
                                  style: Constants.calculateUiLabelStype),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                    onTap: () {
                                      _displayParameterInfo("urgency");
                                    },
                                    child: Icon(Icons.info,
                                        color: Constants.mainColor)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Slider(
                            value: _urgency,
                            min: 1.0,
                            max: 9.0,
                            divisions: 9,
                            label: "${_urgency.round()}",
                            activeColor: Constants.mainColor,
                            inactiveColor: Theme.of(context).primaryColor,
                            onChanged: (double value) {
                              setState(() {
                                _urgency = value;
                              });
                            },
                          ),
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Importance (${_importance.round()})",
                                  style: Constants.calculateUiLabelStype),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                    onTap: () =>
                                        _displayParameterInfo("importance"),
                                    child: Icon(Icons.info,
                                        color: Constants.mainColor)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Slider(
                            value: _importance,
                            min: 1.0,
                            max: 9.0,
                            divisions: 9,
                            label: "${_importance.round()}",
                            activeColor: Constants.mainColor,
                            inactiveColor: Theme.of(context).primaryColor,
                            onChanged: (double value) {
                              setState(() {
                                _importance = value;
                              });
                            },
                          ),
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Complexity (${_complexity.round()})",
                                  style: Constants.calculateUiLabelStype),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                    onTap: () =>
                                        _displayParameterInfo("complexity"),
                                    child: Icon(Icons.info,
                                        color: Constants.mainColor)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Slider(
                            value: _complexity,
                            min: 1.0,
                            max: 9.0,
                            divisions: 9,
                            label: "${_complexity.round()}",
                            activeColor: Constants.mainColor,
                            inactiveColor: Theme.of(context).primaryColor,
                            onChanged: (double value) {
                              setState(() {
                                _complexity = value;
                              });
                            },
                          ),
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Skill (${_skill.round()})",
                                  style: Constants.calculateUiLabelStype),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                    onTap: () => _displayParameterInfo("skill"),
                                    child: Icon(Icons.info,
                                        color: Constants.mainColor)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Slider(
                            value: _skill,
                            min: 1.0,
                            max: 9.0,
                            divisions: 9,
                            label: "${_skill.round()}",
                            activeColor: Constants.mainColor,
                            inactiveColor: Theme.of(context).primaryColor,
                            onChanged: (double value) {
                              setState(() {
                                _skill = value;
                              });
                            },
                          ),
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Frequency (${_frequencey.round()})",
                                  style: Constants.calculateUiLabelStype),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                    onTap: () =>
                                        _displayParameterInfo("frequency"),
                                    child: Icon(Icons.info,
                                        color: Constants.mainColor)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Slider(
                            value: _frequencey,
                            min: 1.0,
                            max: 9.0,
                            divisions: 9,
                            label: "${_frequencey.round()}",
                            activeColor: Constants.mainColor,
                            inactiveColor: Theme.of(context).primaryColor,
                            onChanged: (double value) {
                              setState(() {
                                _frequencey = value;
                              });
                            },
                          ),
                        )
                      ]),
                  Material(
                    color: Constants.mainColor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (isCalculateButtonEnabled()) {
                          _onFormSubmitted();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.surprise,
                              color: Colors.white,
                              size: Constants.loginUiIconSize,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Calculate",
                              style: Constants.loginUiButtonTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is CalculationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CalculationProcessed) {
            CalculationProcessed calculationProcessed = state;
            CalculationResponse calculationResponse =
                calculationProcessed.calculationResponse;
            return Center(
              child: Column(
                children: <Widget>[
                  Text(
                      "Your chance of sucking this is ${calculationResponse.murphy}")
                ],
              ),
            );
          } else {
            return Center(child: Text("Invalid state!"));
          }
        },
      ),
    );
  }

  void _onFormSubmitted() {
    CalculationRequest calculationRequest = CalculationRequest(
        event: _eventNameController.text,
        eventTime: _eventDate,
        urgency: _urgency.round(),
        importance: _importance.round(),
        complexity: _complexity.round(),
        skill: _skill.round(),
        frequency: _frequencey.round());
    _calculationBloc.dispatch(Calculate(calculationRequest));
  }
}
