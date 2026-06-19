// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/activity/data/remote/activity_remote.dart';
import 'package:task_manager/feature/history_task/data/remote/history_task_remote.dart';
import 'package:task_manager/feature/login/data/remote/login_remote.dart';
import 'package:task_manager/feature/project_detail/data/remote/project_detail_remote.dart';
import 'package:task_manager/feature/shared_component/notification/data/remote/notification_remote.dart';
import 'package:task_manager/feature/shared_component/user/data/remote/user_remote.dart';
import 'package:task_manager/feature/task_detail/data/remote/task_detail_remote.dart';
import 'package:task_manager/feature/workspace/data/remote/workspace_remote.dart';
import 'package:task_manager/feature/workspace_detail/data/remote/workspace_detail_remote.dart';

class RemoteServices {
  final WorkspaceRemote workspaceRemote;
  final WorkspaceDetailRemote workspaceDetailRemote;
  final LoginRemote loginRemote;
  final ProjectDetailRemote projectDetailRemote;
  final HistoryTaskRemote historyTaskRemote;
  final TaskDetailRemote taskDetailRemote;
  final ActivityRemote activityRemote;
  final NotificationRemote notificationRemote;
  final UserRemote userRemote;

  RemoteServices({
    required this.workspaceRemote,
    required this.workspaceDetailRemote,
    required this.loginRemote,
    required this.projectDetailRemote,
    required this.historyTaskRemote,
    required this.taskDetailRemote,
    required this.activityRemote,
    required this.notificationRemote,
    required this.userRemote,
  });
}
