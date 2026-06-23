// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_manager/feature/project_detail/data/local/source/label_local_source.dart';
import 'package:task_manager/feature/project_detail/data/local/source/subtask_local_source.dart';
import 'package:task_manager/feature/project_detail/data/local/source/task_label_local_source.dart';
import 'package:task_manager/feature/project_detail/data/local/source/task_local_source.dart';

class ProjectDetailLocal {
  final LabelLocalSource label;
  final TaskLocalSource task;
  final SubtaskLocalSource subtask;
  final TaskLabelLocalSource taskLabel;

  ProjectDetailLocal({
    required this.label,
    required this.task,
    required this.subtask,
    required this.taskLabel,
  });
}
