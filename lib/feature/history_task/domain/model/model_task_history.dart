import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/history_task/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelHistoryTask extends Equatable {
  final String id;
  final String taskId;
  final EnumHistoryField field;
  final String oldValue;
  final String newValue;
  final String changedBy;
  final DateTime changedAt;
  final String workspaceId;

  const ModelHistoryTask({
    required this.id,
    required this.workspaceId,
    required this.taskId,
    required this.field,
    required this.oldValue,
    required this.newValue,
    required this.changedBy,
    required this.changedAt,
  });

  factory ModelHistoryTask.fromJson(Map<String, dynamic> data) {
    return ModelHistoryTask(
      workspaceId: data[EnumHistoryTask.workspaceId.value],
      id: data[EnumHistoryTask.id.value],
      taskId: data[EnumHistoryTask.taskId.value],
      field: EnumHistoryField.fromString(data[EnumHistoryTask.field.value]),
      oldValue: data[EnumHistoryTask.oldValue.value],
      newValue: data[EnumHistoryTask.newValue.value],
      changedBy: data[EnumHistoryTask.changedBy.value],
      changedAt: HelperDateConvert.toDateTime(
        data[EnumHistoryTask.changedAt.value],
      ),
    );
  }

  factory ModelHistoryTask.fromDrift(Map<String, dynamic> data) {
    return ModelHistoryTask(
      workspaceId: data[EnumHistoryTask.workspaceId.name],
      id: data[EnumHistoryTask.id.name],
      taskId: data[EnumHistoryTask.taskId.name],
      field: EnumHistoryField.fromString(data[EnumHistoryTask.field.name]),
      oldValue: data[EnumHistoryTask.oldValue.name],
      newValue: data[EnumHistoryTask.newValue.name],
      changedBy: data[EnumHistoryTask.changedBy.name],
      changedAt: HelperDateConvert.toDateTime(
        data[EnumHistoryTask.changedAt.name],
      ),
    );
  }

  @override
  List<Object?> get props => [
    workspaceId,
    id,
    taskId,
    field,
    oldValue,
    newValue,
    changedBy,
    changedAt,
  ];
}
