import 'package:equatable/equatable.dart';

class ModelTaskLabels extends Equatable {
  final String taskId;
  final String labelId;

  const ModelTaskLabels({required this.taskId, required this.labelId});

  @override
  List<Object?> get props => [taskId, labelId];
}
