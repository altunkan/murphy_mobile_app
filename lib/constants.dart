library Constants;

import 'package:flutter/material.dart';

const apiBaseUrl = "http://192.168.56.1:8080/murphy";
const loginUrl = "$apiBaseUrl/auth/login";
const signupUrl = "$apiBaseUrl/auth/signup";

const mainColor = Color(0xFF18D191);

const loginUiLabelStyle = TextStyle(fontSize: 14.0, fontFamily: 'Roboto');
const loginUiTextStyle = TextStyle(fontFamily: 'Roboto', color: Color(0xFF18D191));