// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/project_detail/data/remote/source/label_remote_source.dart';
import 'package:task_manager/feature/project_detail/data/remote/source/subtask_remote_source.dart';
import 'package:task_manager/feature/project_detail/data/remote/source/task_label_remote_source.dart';
import 'package:task_manager/feature/project_detail/data/remote/source/task_remote_source.dart';

class ProjectDetailRemote {
  final LabelRemoteSource label;
  final TaskRemoteSource task;
  final SubtaskRemoteSource subtask;
  final TaskLabelRemoteSource taskLabel;

  ProjectDetailRemote({
    required this.label,
    required this.task,
    required this.subtask,
    required this.taskLabel,
  });
}
