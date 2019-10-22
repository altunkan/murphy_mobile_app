/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-20 21:19:37 
 * @Last Modified by:   MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Last Modified time: 2019-10-20 21:19:37 
 */
import 'package:json_annotation/json_annotation.dart';

part 'sort.g.dart';

@JsonSerializable()
class Sort {
  bool sorted;
  bool unsorted;
  bool empty;

  Sort(this.sorted, this.unsorted, this.empty);

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

  Map<String, dynamic> toJson() => _$SortToJson(this);
}
