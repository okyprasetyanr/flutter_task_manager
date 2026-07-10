// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/shared/common_widget/listview/custom_column_list.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

import 'package:task_manager/shared/enum/enum_status_state.dart';

class CustomHandlerList<T> extends StatelessWidget {
  final bool isListView;
  final bool smallSpace;
  final EnumStatusState status;
  final ScrollController? controller;
  final List<T> data;
  final List<Widget> Function(T data, EnumStatusState status) content;
  final int? limit;
  final Function(T data)? onPressed;
  final Function(T data)? onOption;
  final bool Function(T data)? specificOption;
  final Widget? Function(T data)? changeOptionIcon;
  final String? dataName;
  final Color? changeColor;
  final bool allowScroll;
  final bool reverse;
  const CustomHandlerList({
    super.key,
    this.isListView = true,
    this.smallSpace = false,
    required this.status,
    this.controller,
    required this.data,
    required this.content,
    this.limit,
    this.onPressed,
    this.onOption,
    this.specificOption,
    this.changeOptionIcon,
    this.dataName,
    this.changeColor,
    this.allowScroll = true,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return isListView
        ? CustomListViewBuilderV(
            status: status,
            controller: controller,
            data: data,
            content: content,
            limit: limit,
            onPressed: onPressed,
            onOption: onOption,
            specificOption: specificOption,
            changeOptionIcon: changeOptionIcon,
            dataName: dataName,
            changeColor: changeColor,
            allowScroll: allowScroll,
            reverse: reverse,
            smallSpace: smallSpace,
          )
        : CustomColumnListV(
            status: status,
            data: data,
            content: content,
            limit: limit,
            onPressed: onPressed,
            onOption: onOption,
            specificOption: specificOption,
            changeOptionIcon: changeOptionIcon,
            dataName: dataName,
            changeColor: changeColor,
            reverse: reverse,
            smallSpace: smallSpace,
          );
  }
}
