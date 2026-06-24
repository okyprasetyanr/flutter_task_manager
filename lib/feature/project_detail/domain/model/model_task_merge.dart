// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_sub_task.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task.dart';
import 'package:task_manager/feature/project_detail/domain/model/model_task_labels.dart';

class ModelTaskMerge extends Equatable {
  final ModelTask dataTask;
  final Set<ModelSubTask> dataSubTask;
  final Set<ModelTaskLabels> dataTaskLabel;
  const ModelTaskMerge({
    required this.dataTask,
    required this.dataSubTask,
    required this.dataTaskLabel,
  });

  ModelTaskMerge copyWith({
    ModelTask? dataTask,
    Set<ModelSubTask>? dataSubTask,
    Set<ModelTaskLabels>? dataTaskLabel,
  }) {
    return ModelTaskMerge(
      dataTask: dataTask ?? this.dataTask,
      dataSubTask: dataSubTask ?? this.dataSubTask,
      dataTaskLabel: dataTaskLabel ?? this.dataTaskLabel,
    );
  }

  @override
  List<Object?> get props => [dataTask, dataSubTask, dataTaskLabel];
}
