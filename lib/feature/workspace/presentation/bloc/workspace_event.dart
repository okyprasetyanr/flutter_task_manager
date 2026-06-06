// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/shared/enum/enum_status_state.dart';

class WorkspaceEvent {}

class WorkspaceEventGetData extends WorkspaceEvent {}

class WorkspaceEventChangeStatus extends WorkspaceEvent {
  EnumStatusState status;
  WorkspaceEventChangeStatus({required this.status});
}
