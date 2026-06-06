import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

// ignore_for_file: non_constant_identifier_names
class ModelWorkspace {
  final String workspaceId;
  final String workspaceName;
  final String workspaceDescription;
  final String workspaceOwnerId;
  final DateTime createdAt;
  final String id_company;

  const ModelWorkspace({
    required this.workspaceId,
    required this.workspaceName,
    required this.workspaceDescription,
    required this.workspaceOwnerId,
    required this.createdAt,
    required this.id_company,
  });

  factory ModelWorkspace.fromJson(Map<String, dynamic> data) {
    return ModelWorkspace(
      workspaceId: data[EnumWorkspace.workspaceId.name],
      workspaceName: data[EnumWorkspace.workspaceName.name],
      workspaceDescription: data[EnumWorkspace.workspaceDescription.name],
      workspaceOwnerId: data[EnumWorkspace.workspaceOwnerId.name],
      createdAt: HelperDateConvert.toDateTime(
        data[EnumWorkspace.createdAt.name],
      ),
      id_company: data[EnumWorkspace.id_company.name],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      EnumWorkspace.workspaceId.name: workspaceId,
      EnumWorkspace.workspaceName.name: workspaceName,
      EnumWorkspace.workspaceDescription.name: workspaceDescription,
      EnumWorkspace.workspaceOwnerId.name: workspaceOwnerId,
      EnumWorkspace.createdAt.name: createdAt,
      EnumWorkspace.id_company.name: id_company,
    };
  }
}
