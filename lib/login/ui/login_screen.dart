/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 20:56:36 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-17 22:20:45
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/bloc.dart';
import '../../authentication/bloc/bloc.dart';
import '../../constants.dart' as Constants;
import '../../signup/ui/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: BlocProvider<LoginBloc>(
        builder: (context) => LoginBloc(),
        child: LoginForm(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isLoginButtonEnabled(LoginState state) =>
      state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
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
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.isSubmitting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 60.0),
                        child: new Text(
                          "Murphy's Law",
                          style: new TextStyle(fontSize: 30.0),
                        ),
                      )
                    ],
                  ),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: Constants.loginUiLabelStyle,
                                suffixIcon: Icon(Icons.email, size: 18)),
                            controller: _emailController,
                            autocorrect: false,
                            autovalidate: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (_) {
                              return !state.isEmailValid
                                  ? 'Invalid Email'
                                  : null;
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: Constants.loginUiLabelStyle,
                                suffixIcon: Icon(Icons.lock, size: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10.0),
                            child: Material(
                              color: Constants.mainColor,
                              child: InkWell(
                                onTap: () {
                                  if (isLoginButtonEnabled(state)) {
                                    _onFormSubmitted();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.email,
                                        color: Colors.white,
                                        size: Constants.loginUiIconSize,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "Sign in with Email",
                                        style: Constants.loginUiButtonTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 5.0, top: 10.0),
                            child: Material(
                              color: Color(0xFF3B5998),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.facebookF,
                                        color: Colors.white,
                                        size: Constants.loginUiIconSize,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "Facebook",
                                        style: Constants.loginUiButtonTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                      Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 20.0, top: 10.0),
                            child: Material(
                              color: Color(0xFFDD4B39),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                        size: Constants.loginUiIconSize,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "Gmail",
                                        style: Constants.loginUiButtonTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: new Text(
                          "Forgot Password",
                          style: Constants.loginUiTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: GestureDetector(
                            child: new Text(
                              "Sign Up",
                              style: Constants.loginUiTextStyle,
                            ),
                            onTap: () {
                              Navigator.of(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignupScreen();
                              }));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
