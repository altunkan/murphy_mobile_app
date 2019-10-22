// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sort _$SortFromJson(Map<String, dynamic> json) {
  return Sort(
    json['sorted'] as bool,
    json['unsorted'] as bool,
    json['empty'] as bool,
  );
}

Map<String, dynamic> _$SortToJson(Sort instance) => <String, dynamic>{
      'sorted': instance.sorted,
      'unsorted': instance.unsorted,
      'empty': instance.empty,
    };
