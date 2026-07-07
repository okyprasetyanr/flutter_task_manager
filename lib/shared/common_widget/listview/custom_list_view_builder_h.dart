// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/loading/custom_loading.dart';
import 'package:task_manager/shared/common_widget/text/custom_text_empty.dart';

class CustomListViewBuilderH<T> extends StatelessWidget {
  final List<T> data;
  final EnumStatusState status;
  final Function(T data) getName;
  final Widget? leftWidget;
  const CustomListViewBuilderH({
    super.key,
    required this.status,
    required this.data,
    required this.getName,
    this.leftWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (status == EnumStatusState.loading && data.isEmpty) {
      return const CustomLoading();
    } else if (status != EnumStatusState.loading && data.isEmpty) {
      return const CustomTextEmpty();
    } else {
      return ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppPropertyColor.black,
              AppPropertyColor.black,
              AppPropertyColor.black,
              AppPropertyColor.transparent,
            ],
            stops: [0, 0.02, 0.98, 1],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: data
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                      color: AppPropertyColor.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (leftWidget != null) ...[
                              leftWidget!,
                              const SizedBox(width: 5),
                            ],
                            Text(getName(e), style: lv05TextStyleWhite),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }
}
