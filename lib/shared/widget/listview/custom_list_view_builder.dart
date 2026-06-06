import 'package:flutter/material.dart';

import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/widget/button/custom_button.dart';
import 'package:task_manager/shared/widget/loading/custom_loading.dart';
import 'package:task_manager/shared/widget/text/custom_text_empty.dart';

class CustomListViewBuilder<T> extends StatelessWidget {
  final EnumStatusState status;
  final List<T> data;
  final List<Widget> Function(T data) content;
  final Function(T data) onPressed;
  const CustomListViewBuilder({
    super.key,
    required this.status,
    required this.data,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (status == EnumStatusState.loading && data.isEmpty) {
      return CustomLoading();
    } else if (status != EnumStatusState.loading && data.isEmpty) {
      return CustomTextEmpty();
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final finalData = data[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomButton(
              backgroundColor: AppPropertyColor.white,
              padding: true,
              onPressed: () {
                onPressed(finalData);
              },
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: content(finalData),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
