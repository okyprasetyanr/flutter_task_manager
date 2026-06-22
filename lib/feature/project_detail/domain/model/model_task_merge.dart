// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/model/model_sub_task.dart';
import 'package:task_manager/shared/model/model_task.dart';
import 'package:task_manager/shared/model/model_task_labels.dart';

class ModelTaskMerge extends Equatable {
  final ModelTask dataTask;
  final Set<ModelSubTask> dataSubTask;
  final Set<ModelTaskLabels> dataTaskLabel;
  const ModelTaskMerge({
    required this.dataTask,
    required this.dataSubTask,
    required this.dataTaskLabel,
  });

  @override
  List<Object?> get props => [dataTask, dataSubTask, dataTaskLabel];
}
