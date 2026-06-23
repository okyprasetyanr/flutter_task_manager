import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_filter/helper_date_filter.dart';
import 'package:uuid/uuid.dart';

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

  factory ModelWorkspace.fromDrift(Map<String, dynamic> data) {
    return ModelWorkspace(
      id: data[EnumWorkspace.id.name],
      name: data[EnumWorkspace.name.name],
      description: data[EnumWorkspace.description.name],
      ownerId: data[EnumWorkspace.ownerId.name],
      createdAt: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumWorkspace.createdAt.name]),
      ),
      companyId: data[EnumWorkspace.companyId.name],
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

  static ModelWorkspace createWorkspace({
    required String name,
    required String description,
    required String companyId,
    required String userId,
  }) {
    return ModelWorkspace(
      id: "WS${Uuid().v4().toString().substring(0, 6)}",
      name: name,
      description: description,
      ownerId: userId,
      createdAt: dateNowYMDBLOC(),
      companyId: companyId,
    );
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

  ModelWorkspace copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    DateTime? createdAt,
    String? companyId,
  }) {
    return ModelWorkspace(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      companyId: companyId ?? this.companyId,
    );
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
