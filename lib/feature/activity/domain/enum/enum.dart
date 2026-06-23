import 'package:task_manager/feature/activity/domain/model/model_activity.dart';
import 'package:task_manager/feature/project_detail/domain/enum/enum.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/model/model_display_history.dart';

enum EnumActivity {
  id('id'),
  taskId('task_id'),
  userId('user_id'),
  action('action'),
  oldValue('old_value'),
  newValue('new_value'),
  createdAt('created_at'),
  workspaceId('workspace_id');

  final String value;
  const EnumActivity(this.value);
}

enum EnumActivityAction {
  createTask('create_task'),
  updateTask('update_task'),
  deleteTask('delete_task'),
  updateStatus('update_status'),
  updatePriority('update_priority'),
  assignUser('assign_user'),
  unassignUser('unassign_user'),
  addLabel('add_label'),
  removeLabel('remove_label'),
  addComment('add_comment'),
  editComment('edit_comment'),
  deleteComment('delete_comment'),
  addAttachment('add_attachment'),
  deleteAttachment('delete_attachment'),
  createSubtask('create_subtask'),
  updateSubtask('update_subtask'),
  completeSubtask('complete_subtask'),
  deleteSubtask('delete_subtask'),
  unknown('unknown');

  const EnumActivityAction(this.value);

  final String value;

  static EnumActivityAction fromValue(String value) {
    return EnumActivityAction.values.firstWhere((e) => e.value == value);
  }
}

extension EnumActivityActionX on EnumActivityAction {
  static EnumActivityAction fromServer(String value) =>
      EnumActivityAction.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumActivityAction.unknown,
      );

  String get text {
    switch (this) {
      case EnumActivityAction.createTask:
        return 'Create Task';

      case EnumActivityAction.updateTask:
        return 'Update Task';

      case EnumActivityAction.deleteTask:
        return 'Delete Task';

      case EnumActivityAction.updateStatus:
        return 'Update Status';

      case EnumActivityAction.updatePriority:
        return 'Update Priority';

      case EnumActivityAction.assignUser:
        return 'Assign User';

      case EnumActivityAction.unassignUser:
        return 'Unassign User';

      case EnumActivityAction.addLabel:
        return 'Add Label';

      case EnumActivityAction.removeLabel:
        return 'Remove Label';

      case EnumActivityAction.addComment:
        return 'Add Comment';

      case EnumActivityAction.editComment:
        return 'Edit Comment';

      case EnumActivityAction.deleteComment:
        return 'Delete Comment';

      case EnumActivityAction.addAttachment:
        return 'Add Attachment';

      case EnumActivityAction.deleteAttachment:
        return 'Delete Attachment';

      case EnumActivityAction.createSubtask:
        return 'Create Subtask';

      case EnumActivityAction.updateSubtask:
        return 'Update Subtask';

      case EnumActivityAction.completeSubtask:
        return 'Complete Subtask';

      case EnumActivityAction.deleteSubtask:
        return 'Delete Subtask';

      case EnumActivityAction.unknown:
        return 'Unknown!';
    }
  }

  static EnumActivityAction fromText(String value) =>
      EnumActivityAction.values.firstWhere(
        (e) => e.text == value,
        orElse: () => EnumActivityAction.unknown,
      );
}

extension ModelActivityX on ModelActivity {
  OldNewDisplayValue display({required Set<ModelUser> users}) {
    switch (action) {
      case EnumActivityAction.createTask:
      case EnumActivityAction.deleteTask:
        return OldNewDisplayValue(
          oldValue: oldValue.isEmpty ? '-' : oldValue,
          newValue: newValue.isEmpty ? '-' : newValue,
        );

      case EnumActivityAction.updateStatus:
        return OldNewDisplayValue(
          oldValue: EnumTaskStatusX.fromServer(oldValue).text,
          newValue: EnumTaskStatusX.fromServer(newValue).text,
        );

      case EnumActivityAction.updatePriority:
        return OldNewDisplayValue(
          oldValue: EnumTaskPriorityX.fromServer(oldValue).text,
          newValue: EnumTaskPriorityX.fromServer(newValue).text,
        );

      case EnumActivityAction.assignUser:
        return OldNewDisplayValue(
          oldValue:
              users.where((e) => e.id == oldValue).firstOrNull?.name ?? '-',
          newValue:
              users.where((e) => e.id == newValue).firstOrNull?.name ?? '-',
        );

      case EnumActivityAction.unassignUser:
        return OldNewDisplayValue(
          oldValue:
              users.where((e) => e.id == oldValue).firstOrNull?.name ?? '-',
          newValue:
              users.where((e) => e.id == newValue).firstOrNull?.name ?? '-',
        );

      case EnumActivityAction.updateTask:
        final parsedOld = HelperDateConvert.toDateTime(oldValue);
        final parsedNew = HelperDateConvert.toDateTime(newValue);

        return OldNewDisplayValue(
          oldValue: oldValue.isNotEmpty
              ? HelperDateConvert.toDisplayUI(date: parsedOld)
              : '-',
          newValue: newValue.isNotEmpty
              ? HelperDateConvert.toDisplayUI(date: parsedNew)
              : '-',
        );

      case EnumActivityAction.addLabel:
      case EnumActivityAction.removeLabel:
      case EnumActivityAction.addComment:
      case EnumActivityAction.editComment:
      case EnumActivityAction.deleteComment:
      case EnumActivityAction.addAttachment:
      case EnumActivityAction.deleteAttachment:
      case EnumActivityAction.createSubtask:
      case EnumActivityAction.updateSubtask:
      case EnumActivityAction.completeSubtask:
      case EnumActivityAction.deleteSubtask:
        return OldNewDisplayValue(
          oldValue: oldValue.isEmpty ? '-' : oldValue,
          newValue: newValue.isEmpty ? '-' : newValue,
        );

      case EnumActivityAction.unknown:
        return OldNewDisplayValue(oldValue: oldValue, newValue: newValue);
    }
  }
}
