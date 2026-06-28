// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/activity/data/local/activity_local.dart';
import 'package:task_manager/feature/history_task/data/local/history_task_local.dart';
import 'package:task_manager/feature/project_detail/data/local/project_detail_local.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/data/local/not_log_local.dart';
import 'package:task_manager/feature/shared_component/user/data/local/user_local.dart';
import 'package:task_manager/feature/task_detail/data/local/task_detail_local.dart';
import 'package:task_manager/feature/workspace/data/local/workspace_local.dart';
import 'package:task_manager/feature/workspace_detail/data/local/workspace_detail_local.dart';

class LocalServices {
  final WorkspaceLocal workspaceLocal;
  final WorkspaceDetailLocal workspaceDetailLocal;
  final UserLocal userLocal;
  final ProjectDetailLocal projectDetailLocal;
  final HistoryTaskLocal historyTaskLocal;
  final TaskDetailLocal taskDetailLocal;
  final ActivityLocal activityLocal;
  final NotLogLocal notificationLocal;

  LocalServices({
    required this.workspaceLocal,
    required this.workspaceDetailLocal,
    required this.userLocal,
    required this.projectDetailLocal,
    required this.historyTaskLocal,
    required this.taskDetailLocal,
    required this.activityLocal,
    required this.notificationLocal,
  });
}
