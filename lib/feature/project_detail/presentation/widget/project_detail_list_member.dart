import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_bloc.dart';
import 'package:task_manager/feature/project_detail/presentation/bloc/project_detail_state.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/style/text_size.dart';
import 'package:task_manager/shared/common_widget/listview/custom_list_view_builder_v.dart';

class ProjectDetailListMember extends StatelessWidget {
  const ProjectDetailListMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppPropertyColor.white,
      child:
          BlocSelector<
            ProjectDetailBloc,
            ProjectDetailState,
            (Set<ModelUser>, EnumStatusState)
          >(
            selector: (state) => state is ProjectDetailStateLoaded
                ? (
                    state.dataProject?.dataProjectMember ?? const {},
                    state.status,
                  )
                : (const {}, EnumStatusState.loading),
            builder: (context, state) {
              return CustomListViewBuilderV<ModelUser>(
                status: state.$2,
                data: state.$1.toList(),
                content: (data, _) => [
                  Text(data.name, style: lv05TextStyle),
                  Text(data.email, style: lv05TextStyle),
                ],
                onPressed: (data) => {},
              );
            },
          ),
    );
  }
}
