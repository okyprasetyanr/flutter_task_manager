import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/helper/bottom_sheet/custom_bottom_sheet.dart';

class FloatingButtonAdd<T extends StateStreamableSource<Object?>>
    extends StatelessWidget {
  final Widget Function(ScrollController scrollController) content;
  const FloatingButtonAdd({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FloatingActionButton(
        backgroundColor: AppPropertyColor.primary,
        elevation: 3,
        child: const Icon(Icons.add_rounded, color: AppPropertyColor.white),
        onPressed: () {
          return customBottomSheet(
            context: context,
            resetItemForm: () {},
            content: (scrollController) {
              return BlocProvider.value(
                value: context.read<T>(),
                child: content(scrollController),
              );
            },
          );
        },
      ),
    );
  }
}
