// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) {
  return Page(
    json['pageable'] == null
        ? null
        : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
    json['totalPages'] as int,
    json['last'] as bool,
    json['totalElements'] as int,
    json['size'] as int,
    json['number'] as int,
    json['sort'] == null
        ? null
        : Sort.fromJson(json['sort'] as Map<String, dynamic>),
    json['numberOfElements'] as int,
    json['first'] as bool,
    json['empty'] as bool,
  );
}

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'pageable': instance.pageable,
      'totalPages': instance.totalPages,
      'last': instance.last,
      'totalElements': instance.totalElements,
      'size': instance.size,
      'number': instance.number,
      'sort': instance.sort,
      'numberOfElements': instance.numberOfElements,
      'first': instance.first,
      'empty': instance.empty,
    };
