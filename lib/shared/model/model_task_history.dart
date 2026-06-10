import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelHistoryTask extends Equatable {
  final String id;
  final String taskId;
  final EnumHistoryField field;
  final String oldValue;
  final String newValue;
  final String changedBy;
  final DateTime changedAt;

  const ModelHistoryTask({
    required this.id,
    required this.taskId,
    required this.field,
    required this.oldValue,
    required this.newValue,
    required this.changedBy,
    required this.changedAt,
  });

  factory ModelHistoryTask.fromJson(Map<String, dynamic> data) {
    return ModelHistoryTask(
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

  @override
  List<Object?> get props => [
    id,
    taskId,
    field,
    oldValue,
    newValue,
    changedBy,
    changedAt,
  ];
}
