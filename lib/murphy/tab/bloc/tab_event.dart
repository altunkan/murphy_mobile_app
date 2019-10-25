/*
 * @Author: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com 
 * @Date: 2019-10-10 18:51:09 
 * @Last Modified by: MEHMET ANIL ALTUNKAN - altunkan[at]gmail.com
 * @Last Modified time: 2019-10-10 18:53:55
 */
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../model/app_tab.dart';

@immutable
abstract class TabEvent extends Equatable {
  TabEvent();
}

class UpdateTab extends TabEvent {
  final AppTab tab;

  UpdateTab(this.tab);

  @override
  String toString() => "UpdateTab { tab: $tab}";

  @override
  List<Object> get props => [this.tab];
}
