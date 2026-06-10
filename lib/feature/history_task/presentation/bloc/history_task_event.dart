// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/shared/enum/enum_status_state.dart';
import 'package:task_manager/shared/model/model_user.dart';
import 'package:task_manager/shared/model/model_workspace.dart';

class HistoryTaskEvent {}

class HistoryTaskEventGetData extends HistoryTaskEvent {
  final ModelWorkspace? data;
  final List<ModelUser>? user;

  HistoryTaskEventGetData({this.data, this.user});
}

class HistoryTaskEventChangeStatus extends HistoryTaskEvent {
  final EnumStatusState status;

  HistoryTaskEventChangeStatus({required this.status});
}
