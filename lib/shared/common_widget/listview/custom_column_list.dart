import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/shared/common_widget/button/custom_button.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading_circular.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class CustomColumnListV<T> extends StatelessWidget {
  final bool smallSpace;
  final EnumStatusState status;
  final List<T> data;
  final List<Widget> Function(T data, EnumStatusState status) content;
  final int? limit;
  final Function(T data)? onPressed;
  final Function(T data)? onOption;
  final bool Function(T data)? specificOption;
  final Widget? Function(T data)? changeOptionIcon;
  final String? dataName;
  final Color? changeColor;
  final bool reverse;

  const CustomColumnListV({
    super.key,
    this.smallSpace = false,
    required this.status,
    required this.data,
    required this.content,
    required this.limit,
    required this.onPressed,
    required this.onOption,
    required this.specificOption,
    required this.changeOptionIcon,
    required this.dataName,
    required this.changeColor,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    if (status == EnumStatusState.loading && data.isEmpty) {
      return const CustomLoadingCircular();
    } else if (status != EnumStatusState.loading && data.isEmpty) {
      return CustomTextEmpty(text: dataName);
    } else {
      final dataSorted = data;

      final bool hasOverflow = limit != null && dataSorted.length > limit!;
      final int displayCount = hasOverflow ? limit! : dataSorted.length;

      final itemsToDisplay = dataSorted.take(displayCount).toList();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (reverse) ...[
            limitWidget(hasOverflow, dataSorted),
            ...listWidget(itemsToDisplay),
          ] else ...[
            ...listWidget(itemsToDisplay),
            limitWidget(hasOverflow, dataSorted),
          ],
        ],
      );
    }
  }

  List<Widget> listWidget(List<T> itemsToDisplay) {
    return itemsToDisplay.map((finalData) {
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
                        ? () => onPressed!(finalData)
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
    }).toList();
  }

  Widget limitWidget(bool hasOverflow, List<T> dataSorted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasOverflow)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '(...+${dataSorted.length - limit!})',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget onPressedAction(T finalData) {
    return CustomButton(
      backgroundColor: AppPropertyColor.white,
      onPressed: onOption != null ? () => onOption!(finalData) : null,
      child: changeOptionIcon != null
          ? changeOptionIcon!(finalData)
          : Icon(Icons.edit_rounded, color: AppPropertyColor.primary),
    );
  }
}
