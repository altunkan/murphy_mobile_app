/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-07 21:45:26 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-20 19:39:02
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../bloc/bloc.dart';
import '../../authentication/bloc/bloc.dart';
import '../../constants.dart' as Constants;

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: BlocProvider<SignupBloc>(
        builder: (context) => SignupBloc(),
        child: SignupForm(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key key}) : super(key: key);

  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  SignupBloc _signupBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isRegisterButtonEnabled(SignupState state) =>
      state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _retypePasswordController.addListener(_onRetypePasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.isFailure) {
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
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          Navigator.of(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => App()));
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          if (state.isSubmitting || state.isSuccess) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                                prefixIcon: Icon(Icons.email,
                                    color: Theme.of(context).primaryColor)),
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
                            autovalidate: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: Constants.loginUiLabelStyle,
                                prefixIcon: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor)),
                            validator: (_) {
                              return !state.isPasswordValid
                                  ? "Passwords do not match"
                                  : null;
                            },
                          ),
                          TextFormField(
                              obscureText: true,
                              autocorrect: false,
                              autovalidate: true,
                              controller: _retypePasswordController,
                              decoration: InputDecoration(
                                  labelText: "Re-type Password",
                                  labelStyle: Constants.loginUiLabelStyle,
                                  prefixIcon: Icon(Icons.lock,
                                      color: Theme.of(context).primaryColor)),
                              validator: (_) {
                                return !state.isPasswordValid
                                    ? "Passwords do not match"
                                    : null;
                              }),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10.0),
                            child: Material(
                              color: Constants.mainColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                onTap: () {
                                  if (isRegisterButtonEnabled(state)) {
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
                                        Icons.person_add,
                                        color: Colors.white,
                                        size: Constants.loginUiIconSize + 4,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "Register",
                                        style: Constants.loginUiButtonTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
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
    _retypePasswordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _signupBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _signupBloc.dispatch(Submitted(
        email: _emailController.text, password: _passwordController.text));
  }

  void _onPasswordChanged() {
    _signupBloc.dispatch(PasswordChanged(
        password: _passwordController.text,
        retypePassword: _retypePasswordController.text));
  }

  void _onRetypePasswordChanged() {
    _signupBloc.dispatch(RetypePasswordChanged(
        password: _passwordController.text,
        retypePassword: _retypePasswordController.text));
  }
}
