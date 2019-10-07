/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-07 21:45:26 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-07 23:30:58
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../bloc/bloc.dart';
import '../../authentication/bloc/bloc.dart';
import '../../constants.dart' as Constants;

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Register Failure'),
                    Icon(Icons.error)
                  ]),
            ));
        } else if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Register"),
            ),
            body: SingleChildScrollView(
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
                              autovalidate: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: Constants.loginUiLabelStyle,
                                  suffixIcon: Icon(Icons.lock, size: 18)),
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
                                    labelText: "Retype Password",
                                    labelStyle: Constants.loginUiLabelStyle,
                                    suffixIcon: Icon(Icons.lock, size: 18)),
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
                              child: SignInButtonBuilder(
                                text: 'Register',
                                icon: Icons.person,
                                backgroundColor: Constants.mainColor,
                                onPressed: () {
                                  print("test");
                                  isRegisterButtonEnabled(state)
                                      ? _onFormSubmitted()
                                      : null;
                                },
                              )),
                        ),
                      ],
                    )
                  ],
                ),
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
