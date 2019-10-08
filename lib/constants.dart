library Constants;

import 'package:flutter/material.dart';

const apiBaseUrl = "http://192.168.56.1:8080/murphy";
const loginUrl = "$apiBaseUrl/auth/login";
const signupUrl = "$apiBaseUrl/auth/signup";

const mainColor = Color(0xFF18D191);

const loginUiLabelStyle = TextStyle(fontSize: 16.0);
const loginUiTextStyle = TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500);
const loginUiIconSize = 18.0;