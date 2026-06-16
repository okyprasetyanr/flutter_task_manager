// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceDetailProjectMember extends StatelessWidget {
  final List<ModelUser> data;
  final EnumStatusState status;
  const WorkspaceDetailProjectMember({
    super.key,
    required this.data,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            borderRadius: BorderRadius.circular(6),
            elevation: 3,
            color: AppPropertyColor.white,
            child: Text(data[index].name),
          ),
        );
      },
    );
  }
}
