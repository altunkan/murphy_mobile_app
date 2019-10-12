/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-09 22:45:09 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-09 22:46:49
 */

import 'package:meta/meta.dart';

class UnauthorizedException implements Exception {
  final String message;
  
  UnauthorizedException({@required this.message});
}