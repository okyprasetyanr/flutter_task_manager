// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';
import 'package:task_manager/shared/widget/text/custom_text_empty.dart';

class CustomListViewBuilderH<T> extends StatelessWidget {
  final List<T> data;
  final EnumStatusState status;
  final Function(T data) getName;
  const CustomListViewBuilderH({
    super.key,
    required this.status,
    required this.data,
    required this.getName,
  });

  @override
  Widget build(BuildContext context) {
    if (status == EnumStatusState.loading && data.isEmpty) {
      return const CustomLoading();
    } else if (status != EnumStatusState.loading && data.isEmpty) {
      return const CustomTextEmpty();
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: data
              .map(
                (e) => Card(
                  color: AppPropertyColor.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(getName(e), style: lv05TextStyle),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
  }
}
