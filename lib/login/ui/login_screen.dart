/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 20:56:36 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-08 23:15:56
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../bloc/bloc.dart';
import '../../authentication/bloc/bloc.dart';
import '../../constants.dart' as Constants;
import '../../signup/ui/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          /*
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Login Failure'), Icon(Icons.error)]),
            ));
          */
        } else if (state.isSubmitting) {
          Center(
            child: CircularProgressIndicator(),
          );
          /*
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          */
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Constants.mainColor,
                                //borderRadius: BorderRadius.circular(9.0)
                              ),
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
                                    style: Constants.loginUiTextStyle,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 5.0, top: 2.0),
                            child: SignInButton(
                              Buttons.Facebook,
                              onPressed: () {},
                              text: "Facebook",
                            )),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 20.0, top: 2.0),
                            child: SignInButton(
                              Buttons.Google,
                              onPressed: () {},
                              text: "Gmail",
                            )),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
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
                  ),
                  Expanded(
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
            resizeToAvoidBottomInset: false,
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
