/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-07 21:21:28 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-07 22:00:14
 */
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignupEvent extends Equatable {
  SignupEvent([List props = const []]) : super(props);
}

class EmailChanged extends SignupEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends SignupEvent {
  final String password;
  final String retypePassword;

  PasswordChanged({@required this.password, @required this.retypePassword}) : super([password, retypePassword]);
}

class RetypePasswordChanged extends SignupEvent {
  final String password;
  final String retypePassword;

  RetypePasswordChanged({@required this.password, @required this.retypePassword}) : super([password, retypePassword]);
}

class Submitted extends SignupEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() {
    return 'Submitted { email: $email }';
  }
}
