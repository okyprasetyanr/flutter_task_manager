import 'package:flutter/material.dart';

import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class CustomListViewBuilderV<T> extends StatelessWidget {
  final EnumStatusState status;
  final ScrollController? controller;
  final List<T> data;
  final List<Widget> Function(T data, EnumStatusState status) content;
  final int? limit;
  final Function(T data)? onPressed;
  final Function(T data)? onEdit;

  const CustomListViewBuilderV({
    super.key,
    this.limit,
    this.controller,
    required this.status,
    required this.data,
    required this.content,
    this.onPressed,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (status == EnumStatusState.loading && data.isEmpty) {
      return const CustomLoading();
    } else if (status != EnumStatusState.loading && data.isEmpty) {
      return const CustomTextEmpty();
    } else {
      final bool hasOverflow = limit != null && data.length > limit!;
      final int displayCount = hasOverflow ? limit! + 1 : data.length;

      return ListView.builder(
        controller: controller,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        itemCount: displayCount,
        itemBuilder: (context, index) {
          if (hasOverflow && index == limit) {
            final int remainingData = data.length - limit!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '(...+$remainingData)',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          final finalData = data[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              color: AppPropertyColor.white,
              elevation: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: AppPropertyColor.white,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: onPressed != null
                            ? () {
                                onPressed!(finalData);
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: content(finalData, status),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    CustomButton(
                      backgroundColor: AppPropertyColor.white,
                      onPressed: onEdit != null
                          ? () {
                              onEdit!(finalData);
                            }
                          : null,
                      child: Icon(
                        Icons.edit_rounded,
                        color: AppPropertyColor.primary,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
