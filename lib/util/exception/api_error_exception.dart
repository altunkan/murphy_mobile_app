/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-08 20:32:22 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-08 20:35:15
 */

import 'package:meta/meta.dart';

import '../../util/model/api_error.dart';

class ApiErrorException implements Exception {
  final ApiError apiError;

  ApiErrorException({@required this.apiError});
}