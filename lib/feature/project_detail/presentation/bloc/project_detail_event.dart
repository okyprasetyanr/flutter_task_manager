import 'package:task_manager/feature/workspace_detail/domain/model/model_project_merge.dart';
import 'package:task_manager/shared/enum/enum_status_state.dart';

class ProjectDetailEvent {}

class ProjectDetailEventGetData extends ProjectDetailEvent {
  final ModelProjectMerge? data;

  ProjectDetailEventGetData({this.data});
}

class ProjectDetailEventChangeStatus extends ProjectDetailEvent {
  final EnumStatusState status;

  ProjectDetailEventChangeStatus({required this.status});
}
