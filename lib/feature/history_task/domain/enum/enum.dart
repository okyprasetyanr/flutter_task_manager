import 'package:task_manager/feature/history_task/domain/model/model_task_history.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/model/model_display_history.dart';

enum EnumHistoryTask {
  id('id'),
  taskId('task_id'),
  field('field'),
  oldValue('old_value'),
  newValue('new_value'),
  changedBy('changed_by'),
  changedAt('changed_at'),
  workspaceId('workspace_id');

  final String value;
  const EnumHistoryTask(this.value);
}

enum EnumHistoryField {
  status,
  priority,
  assigneeId,
  storyPoint,
  dueDate;

  String get text {
    switch (this) {
      case EnumHistoryField.status:
        return 'Status';

      case EnumHistoryField.priority:
        return 'Priority';

      case EnumHistoryField.assigneeId:
        return 'AssigneeId';

      case EnumHistoryField.storyPoint:
        return 'Story Point';

      case EnumHistoryField.dueDate:
        return 'Due Date';
    }
  }

  static EnumHistoryField fromString(String value) {
    return EnumHistoryField.values.firstWhere((e) => e.text == value);
  }
}

extension ModelHistoryTaskX on ModelHistoryTask {
  OldNewDisplayValue display({required Set<ModelUser> users}) {
    switch (field) {
      case EnumHistoryField.assigneeId:
        return OldNewDisplayValue(
          oldValue:
              users.where((e) => e.id == oldValue).firstOrNull?.name ?? '-',
          newValue:
              users.where((e) => e.id == newValue).firstOrNull?.name ?? '-',
        );

      case EnumHistoryField.dueDate:
        return OldNewDisplayValue(
          oldValue: HelperDateConvert.toDisplayUI(
            date: HelperDateConvert.toDateTime(oldValue),
          ),
          newValue: HelperDateConvert.toDisplayUI(
            date: HelperDateConvert.toDateTime(newValue),
          ),
        );
      case EnumHistoryField.status:
        return OldNewDisplayValue(
          oldValue: EnumTaskStatusX.fromServer(oldValue).text,
          newValue: EnumTaskStatusX.fromServer(newValue).text,
        );

      case EnumHistoryField.priority:
        return OldNewDisplayValue(
          oldValue: EnumTaskPriorityX.fromServer(oldValue).text,
          newValue: EnumTaskPriorityX.fromServer(newValue).text,
        );
      default:
        return OldNewDisplayValue(oldValue: oldValue, newValue: newValue);
    }
  }
}
