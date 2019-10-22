/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 20:56:36 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-20 19:41:26
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
        elevation: 0.0,
        title: Text("Login"),
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
  final double _padding = 16.0;
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
          if (state.isSubmitting || state.isSuccess) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(top: 30),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _padding),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _emailController,
                        autocorrect: false,
                        autovalidate: true,
                        keyboardType: TextInputType.emailAddress,
                        validator: (_) {
                          return !state.isEmailValid ? 'Invalid Email' : null;
                        },
                        decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                      TextFormField(
                        obscureText: true,
                        autocorrect: false,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: Constants.loginUiLabelStyle,
                            prefixIcon: Icon(Icons.lock,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _padding),
                child: Material(
                  color: Constants.mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  child: Text("Forgot your password?",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Divider(
                            //thickness: 1.0,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Text("Or connect with",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Divider(
                          //thickness: 1.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        color: Color(0xFF3B5998),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                    ),
                    SizedBox(height: 0, width: 10),
                    Expanded(
                      child: Material(
                        color: Color(0xFFDD4B39),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Divider(
                            //thickness: 1.0,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Text("New user?",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    SizedBox(height: 0, width: 10),
                    GestureDetector(
                        child: Container(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Constants.mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SignupScreen();
                          }));
                        }),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Divider(
                          //thickness: 1.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
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
