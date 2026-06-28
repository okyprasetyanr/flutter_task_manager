import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/notification_and_logout/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelNotification extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const ModelNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory ModelNotification.fromJson(Map<String, dynamic> data) {
    return ModelNotification(
      id: data[EnumNotification.id.value],
      userId: data[EnumNotification.userId.value],
      title: data[EnumNotification.title.value],
      body: data[EnumNotification.body.value],
      isRead: data[EnumNotification.isRead.value],
      createdAt: HelperDateConvert.toDateTime(
        data[EnumNotification.createdAt.value],
      ),
    );
  }

  factory ModelNotification.fromDrift(Map<String, dynamic> data) {
    return ModelNotification(
      id: data[EnumNotification.id.name],
      userId: data[EnumNotification.userId.name],
      title: data[EnumNotification.title.name],
      body: data[EnumNotification.body.name],
      isRead: data[EnumNotification.isRead.name],
      createdAt: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(
          data[EnumNotification.createdAt.name],
        ),
      ),
    );
  }

  static Map<String, dynamic> updateIsRead({required String notificationId}) {
    return {
      EnumNotification.id.value: notificationId,
      EnumNotification.isRead.value: true,
    };
  }

  @override
  List<Object?> get props => [id, userId, title, body, isRead, createdAt];
}
