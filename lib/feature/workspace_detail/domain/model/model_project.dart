import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:uuid/uuid.dart';

class ModelProject extends Equatable {
  final String id;
  final String name;
  final String type;
  final EnumProjectStatus status;
  final String createdBy;
  final int totalContribut;
  final DateTime createdAt;
  final DateTime start;
  final DateTime end;
  final String workspaceId;

  const ModelProject({
    required this.createdAt,
    required this.workspaceId,
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.createdBy,
    required this.totalContribut,
    required this.start,
    required this.end,
  });

  factory ModelProject.fromJson(Map<String, dynamic> data) {
    return ModelProject(
      createdAt: HelperDateConvert.toDateTime(
        data[EnumProject.createdAt.value],
      ),
      workspaceId: data[EnumProject.workspaceId.value],
      id: data[EnumProject.id.value],
      name: data[EnumProject.name.value],
      type: data[EnumProject.type.value],
      status: EnumProjectStatusX.fromText(data[EnumProject.status.value]),
      createdBy: data[EnumProject.createdBy.value],
      totalContribut: data[EnumProject.totalContribut.value],
      start: HelperDateConvert.toDateTime(data[EnumProject.start.value]),
      end: HelperDateConvert.toDateTime(data[EnumProject.end.value]),
    );
  }

  ModelProject copyWith({
    String? id,
    String? name,
    String? type,
    EnumProjectStatus? status,
    String? createdBy,
    int? totalContribut,
    DateTime? start,
    DateTime? end,
    DateTime? createdAt,
    String? workspaceId,
  }) {
    return ModelProject(
      createdAt: createdAt ?? this.createdAt,
      workspaceId: workspaceId ?? this.workspaceId,
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      totalContribut: totalContribut ?? this.totalContribut,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumProject.id.value: id,
      EnumProject.name.value: name,
      EnumProject.start.value: start,
      EnumProject.end.value: end,
      EnumProject.status.value: status,
      EnumProject.createdBy.value: createdBy,
      EnumProject.totalContribut.value: totalContribut,
      EnumProject.type.value: type,
      EnumProject.workspaceId.value: workspaceId,
    };
  }

  static ModelProject createProject({
    required String name,
    required DateTime start,
    required DateTime end,
    required DateTime createdAt,
    required int totalContribut,
    required String type,
    required EnumProjectStatus status,
    required String workspaceId,
    required String createdBy,
  }) {
    return ModelProject(
      createdAt: createdAt,
      workspaceId: workspaceId,
      id: "PRJ${Uuid().v4().substring(0, 6)}",
      name: name,
      type: type,
      status: status,
      createdBy: createdBy,
      totalContribut: totalContribut,
      start: start,
      end: end,
    );
  }

  static Map<String, dynamic> projectGetChangedData({
    required Map<String, dynamic> original,
    required Map<String, dynamic> edited,
  }) {
    Map<String, dynamic> changedData = {
      EnumProject.id.value: original[EnumProject.id.value],
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
    workspaceId,
    id,
    name,
    type,
    status,
    createdBy,
    totalContribut,
    createdAt,
    start,
    end,
  ];
}
