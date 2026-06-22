import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelActivity extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final EnumActivityAction action;
  final String oldValue;
  final String newValue;
  final DateTime createdAt;
  final String workspaceId;

  const ModelActivity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.action,
    required this.oldValue,
    required this.newValue,
    required this.createdAt,
    required this.workspaceId,
  });

  factory ModelActivity.fromJson(Map<String, dynamic> data) {
    return ModelActivity(
      id: data[EnumActivity.id.value],
      taskId: data[EnumActivity.taskId.value],
      userId: data[EnumActivity.userId.value],
      action: EnumActivityActionX.fromServer(data[EnumActivity.action.value]),
      oldValue: data[EnumActivity.oldValue.value],
      newValue: data[EnumActivity.newValue.value],
      createdAt: HelperDateConvert.toDateTime(
        data[EnumActivity.createdAt.value],
      ),
      workspaceId: data[EnumActivity.workspaceId.value],
    );
  }

  factory ModelActivity.fromDrift(Map<String, dynamic> data) {
    return ModelActivity(
      id: data[EnumActivity.id.name],
      taskId: data[EnumActivity.taskId.name],
      userId: data[EnumActivity.userId.name],
      action: EnumActivityActionX.fromServer(data[EnumActivity.action.name]),
      oldValue: data[EnumActivity.oldValue.name],
      newValue: data[EnumActivity.newValue.name],
      createdAt: HelperDateConvert.toDateTime(
        data[EnumActivity.createdAt.name],
      ),
      workspaceId: data[EnumActivity.workspaceId.name],
    );
  }

  @override
  List<Object?> get props => [
    id,
    taskId,
    userId,
    action,
    oldValue,
    newValue,
    createdAt,
    workspaceId,
  ];
}
