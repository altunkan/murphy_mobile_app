// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pageable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pageable _$PageableFromJson(Map<String, dynamic> json) {
  return Pageable(
    json['sort'] == null
        ? null
        : Sort.fromJson(json['sort'] as Map<String, dynamic>),
    json['offset'] as int,
    json['pageSize'] as int,
    json['pageNumber'] as int,
    json['paged'] as bool,
    json['unpaged'] as bool,
  );
}

Map<String, dynamic> _$PageableToJson(Pageable instance) => <String, dynamic>{
      'sort': instance.sort,
      'offset': instance.offset,
      'pageSize': instance.pageSize,
      'pageNumber': instance.pageNumber,
      'paged': instance.paged,
      'unpaged': instance.unpaged,
    };
