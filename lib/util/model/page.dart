/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-20 21:19:22 
 * @Last Modified by:   MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Last Modified time: 2019-10-20 21:19:22 
 */
import 'package:json_annotation/json_annotation.dart';

import 'pageable.dart';
import 'sort.dart';

part 'page.g.dart';

@JsonSerializable()
class Page {
  Pageable pageable;
  int totalPages;
  bool last;
  int totalElements;
  int size;
  int number;
  Sort sort;
  int numberOfElements;
  bool first;
  bool empty;

  Page(
    this.pageable,
    this.totalPages,
    this.last,
    this.totalElements,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  );

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}
