import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';

void customBottomSheet({
  required BuildContext context,
  required VoidCallback? resetItemForm,
  required Widget Function(ScrollController scrollController) content,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppPropertyColor.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: true,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppPropertyColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SafeArea(
                bottom: true,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppPropertyColor.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: content(scrollController)),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ).whenComplete(() {
    resetItemForm?.call();
  });
}
