/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-03 19:24:37 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-09 23:02:57
 */

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../model/user.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState();
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object> get props => null;
}

class Authenticated extends AuthenticationState {
  final User user;

  Authenticated({@required this.user});

  @override
  String toString() => 'Authenticated { user.email: ${user.email} }';

  @override
  List<Object> get props => [this.user];
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object> get props => null;
}
