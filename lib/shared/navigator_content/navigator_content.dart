import 'package:task_manager/core/routes/routes_enum.dart';

class NavigatorContent {
  static List<Map<String, dynamic>> activityHistoryTaskProjectDetail = [
    {"toContext": RoutesEnum.workspaceDetail, "text_menu": "Workspace Detail"},
    {"toContext": RoutesEnum.historyTask, "text_menu": "History Task"},
    {"toContext": RoutesEnum.activity, "text_menu": "Activity Task"},
  ];
}
