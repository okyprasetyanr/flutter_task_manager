import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelWorkspace extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final DateTime createdAt;
  final String companyId;

  const ModelWorkspace({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.createdAt,
    required this.companyId,
  });

  factory ModelWorkspace.fromJson(Map<String, dynamic> data) {
    return ModelWorkspace(
      id: data[EnumWorkspace.id.value],
      name: data[EnumWorkspace.name.value],
      description: data[EnumWorkspace.description.value],
      ownerId: data[EnumWorkspace.ownerId.value],
      createdAt: HelperDateConvert.toDateTime(
        data[EnumWorkspace.createdAt.value],
      ),
      companyId: data[EnumWorkspace.companyId.value],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumWorkspace.id.value: id,
      EnumWorkspace.name.value: name,
      EnumWorkspace.description.value: description,
      EnumWorkspace.ownerId.value: ownerId,
      EnumWorkspace.createdAt.value: HelperDateConvert.toJsonISO(createdAt),
      EnumWorkspace.companyId.value: companyId,
    };
  }

  static Map<String, dynamic> workspaceGetChangedData({
    required Map<String, dynamic> original,
    required Map<String, dynamic> edited,
  }) {
    Map<String, dynamic> changedData = {
      EnumWorkspace.id.value: original[EnumWorkspace.id.value],
    };

    edited.forEach((key, value) {
      if (original[key] != value) {
        changedData[key] = value;
      }
    });

    return changedData;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    ownerId,
    createdAt,
    companyId,
  ];
}
