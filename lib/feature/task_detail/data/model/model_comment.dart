import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/task_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelComment extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ModelComment({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelComment.fromJson(Map<String, dynamic> data) {
    return ModelComment(
      id: data[EnumComment.id.value],
      taskId: data[EnumComment.taskId.value],
      userId: data[EnumComment.userId.value],
      content: data[EnumComment.content.value],
      createdAt: HelperDateConvert.toDateTime(
        data[EnumComment.createdAt.value],
      ),
      updatedAt: HelperDateConvert.toDateTime(
        data[EnumComment.updatedAt.value],
      ),
    );
  }

  factory ModelComment.fromDrift(Map<String, dynamic> data) {
    return ModelComment(
      id: data[EnumComment.id.name],
      taskId: data[EnumComment.taskId.name],
      userId: data[EnumComment.userId.name],
      content: data[EnumComment.content.name],
      createdAt: HelperDateConvert.toDateTime(data[EnumComment.createdAt.name]),
      updatedAt: HelperDateConvert.toDateTime(data[EnumComment.updatedAt.name]),
    );
  }

  @override
  List<Object?> get props => [
    id,
    taskId,
    userId,
    content,
    createdAt,
    updatedAt,
  ];
}
