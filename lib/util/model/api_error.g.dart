// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiErrorWrapper _$ApiErrorWrapperFromJson(Map<String, dynamic> json) {
  return ApiErrorWrapper(
    apierror: json['apierror'] == null
        ? null
        : ApiError.fromJson(json['apierror'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ApiErrorWrapperToJson(ApiErrorWrapper instance) =>
    <String, dynamic>{
      'apierror': instance.apierror,
    };

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) {
  return ApiError(
    status: json['status'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
      'status': instance.status,
      'timestamp': instance.timestamp?.toIso8601String(),
      'message': instance.message,
    };
