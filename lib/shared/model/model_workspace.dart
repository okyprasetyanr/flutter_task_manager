import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelWorkspace extends Equatable {
  final String workspaceId;
  final String workspaceName;
  final String workspaceDescription;
  final String workspaceOwnerId;
  final DateTime createdAt;
  final String companyId;

  const ModelWorkspace({
    required this.workspaceId,
    required this.workspaceName,
    required this.workspaceDescription,
    required this.workspaceOwnerId,
    required this.createdAt,
    required this.companyId,
  });

  factory ModelWorkspace.fromJson(Map<String, dynamic> data) {
    return ModelWorkspace(
      workspaceId: data[EnumWorkspace.workspaceId.value],
      workspaceName: data[EnumWorkspace.workspaceName.value],
      workspaceDescription: data[EnumWorkspace.workspaceDescription.value],
      workspaceOwnerId: data[EnumWorkspace.workspaceOwnerId.value],
      createdAt: HelperDateConvert.toDateTime(
        data[EnumWorkspace.createdAt.value],
      ),
      companyId: data[EnumWorkspace.companyId.value],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      EnumWorkspace.workspaceId.value: workspaceId,
      EnumWorkspace.workspaceName.value: workspaceName,
      EnumWorkspace.workspaceDescription.value: workspaceDescription,
      EnumWorkspace.workspaceOwnerId.value: workspaceOwnerId,
      EnumWorkspace.createdAt.value: createdAt,
      EnumWorkspace.companyId.value: companyId,
    };
  }

  @override
  List<Object?> get props => [
    workspaceId,
    workspaceName,
    workspaceDescription,
    workspaceOwnerId,
    createdAt,
    companyId,
  ];
}
