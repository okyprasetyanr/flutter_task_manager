import 'package:flutter/material.dart';
import 'package:task_manager/core/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/style/text_size.dart';

class SharedMemberList extends StatelessWidget {
  final Set<ModelUser> data;
  final EnumStatusState status;
  final ModelUser? hightlightUser;
  const SharedMemberList({
    super.key,
    required this.data,
    required this.status,
    this.hightlightUser,
  });

  @override
  Widget build(BuildContext context) {
    final listUser = data.toList();
    if (hightlightUser != null) {
      listUser.sort((a, b) {
        if (a.id == hightlightUser!.id) return -1;
        if (b.id == hightlightUser!.id) return 1;
        return 0;
      });
    }
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
        itemCount: listUser.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Material(
              borderRadius: BorderRadius.circular(6),
              elevation: 3,
              color: hightlightUser != null
                  ? listUser[index].id == hightlightUser!.id
                        ? AppPropertyColor.secondPrimary
                        : AppPropertyColor.primary
                  : AppPropertyColor.primary,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(listUser[index].name, style: lv05TextStyleWhite),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
