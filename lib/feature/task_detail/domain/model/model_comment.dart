// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'package:task_manager/feature/task_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelComment extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isOwned;

  const ModelComment({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isOwned,
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

  factory ModelComment.fromDrift({
    required Map<String, dynamic> data,
    required bool isOwned,
  }) {
    return ModelComment(
      id: data[EnumComment.id.name],
      taskId: data[EnumComment.taskId.name],
      userId: data[EnumComment.userId.name],
      content: data[EnumComment.content.name],
      createdAt: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumComment.createdAt.name]),
      ),
      updatedAt: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumComment.updatedAt.name]),
      ),
      isOwned: isOwned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumComment.id.value: id,
      EnumComment.taskId.value: taskId,
      EnumComment.userId.value: userId,
      EnumComment.content.value: content,
      EnumComment.createdAt.value: HelperDateConvert.toJsonISO(createdAt),
      EnumComment.updatedAt.value: HelperDateConvert.toJsonISO(updatedAt),
    };
  }

  static ModelComment createComment({
    required String taskId,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) {
    return ModelComment(
      id: "COM${Uuid().v4().substring(0, 6)}",
      taskId: taskId,
      userId: userId,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
    isOwned,
  ];
}
