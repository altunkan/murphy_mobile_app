library constants;

import 'package:flutter/material.dart';

const apiBaseUrl =
    "http://192.168.1.20:8080/murphy"; //"http://192.168.56.1:8080/murphy";
const loginUrl = "$apiBaseUrl/auth/login";
const signupUrl = "$apiBaseUrl/auth/signup";
const userUrl = "$apiBaseUrl/user/me";
const calculateUrl = "$apiBaseUrl/calculate";
const listEventUrl = "$apiBaseUrl/list";
const updateEventUrl = "$apiBaseUrl/update";

const tokenValue = "token";
const tokenName = "Authorization";
const tokenType = "Bearer";

const mainColor = Color(0xFF18D191);

const loginUiLabelStyle = TextStyle(fontSize: 16.0);
const loginUiButtonTextStyle =
    TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500);
const loginUiTextStyle =
    TextStyle(fontSize: 16.0, color: mainColor, fontWeight: FontWeight.w400);
const loginUiIconSize = 16.0;

const calculateUiLabelStype = TextStyle(fontSize: 14.0);
