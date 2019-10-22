/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-20 21:19:27 
 * @Last Modified by:   MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Last Modified time: 2019-10-20 21:19:27 
 */
import 'package:json_annotation/json_annotation.dart';

import 'sort.dart';

part 'pageable.g.dart';

@JsonSerializable()
class Pageable {
  Sort sort;
  int offset;
  int pageSize;
  int pageNumber;
  bool paged;
  bool unpaged;

  Pageable(this.sort, this.offset, this.pageSize, this.pageNumber, this.paged,
      this.unpaged);

  factory Pageable.fromJson(Map<String, dynamic> json) =>
      _$PageableFromJson(json);

  Map<String, dynamic> toJson() => _$PageableToJson(this);
}
