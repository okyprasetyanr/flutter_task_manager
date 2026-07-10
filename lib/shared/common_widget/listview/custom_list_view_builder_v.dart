// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_circular.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class CustomListViewBuilderV<T> extends StatelessWidget {
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

  const CustomListViewBuilderV({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
    if (status == EnumStatusState.loading && data.isEmpty) {
      return const CustomLoadingCircular();
    } else if (status != EnumStatusState.loading && data.isEmpty) {
      return CustomTextEmpty(text: dataName);
    } else {
      final bool hasOverflow = limit != null && data.length > limit!;
      final int displayCount = hasOverflow ? limit! + 1 : data.length;

      return ListView.builder(
        physics: allowScroll
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
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

          final bool showOptionButton =
              onOption != null &&
              (specificOption == null || specificOption!(finalData));

          return Padding(
            padding: EdgeInsets.only(bottom: smallSpace ? 0 : 12),
            child: Card(
              color: AppPropertyColor.white,
              elevation: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: changeColor ?? AppPropertyColor.white,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: onPressed != null
                            ? () {
                                onPressed!(finalData);
                              }
                            : null,
                        child: Padding(
                          padding: EdgeInsets.all(smallSpace ? 8 : 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: content(finalData, status),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (showOptionButton) onPressedAction(finalData),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget onPressedAction(T finalData) {
    return CustomButton(
      backgroundColor: AppPropertyColor.white,
      onPressed: onOption != null
          ? () {
              onOption!(finalData);
            }
          : null,
      child: changeOptionIcon != null
          ? changeOptionIcon!(finalData)
          : Icon(Icons.edit_rounded, color: AppPropertyColor.primary),
    );
  }
}
