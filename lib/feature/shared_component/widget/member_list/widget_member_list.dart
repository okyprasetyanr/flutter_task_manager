import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';

class SharedWidgetMemberList extends StatelessWidget {
  final Set<ModelUser> data;
  final EnumStatusState status;
  const SharedWidgetMemberList({
    super.key,
    required this.data,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              borderRadius: BorderRadius.circular(6),
              elevation: 3,
              color: AppPropertyColor.primary,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    data.elementAt(index).name,
                    style: lv05TextStyleWhite,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
