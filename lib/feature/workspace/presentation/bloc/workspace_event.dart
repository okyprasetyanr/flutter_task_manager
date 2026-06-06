// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/workspace/domain/enum/workspace_enum_status_bloc.dart';

class WorkspaceEvent {}

class WorkspaceEventGetData extends WorkspaceEvent {
  WorkspaceEnumStatusBloc status;
  WorkspaceEventGetData({required this.status});
}

class WorkspaceEventChangeStatus extends WorkspaceEvent {
  WorkspaceEnumStatusBloc status;
  WorkspaceEventChangeStatus({required this.status});
}
