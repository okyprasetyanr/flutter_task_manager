import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/workspace_detail/domain/enum/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';
import 'package:uuid/uuid.dart';

class ModelProject extends Equatable {
  final String id;
  final String name;
  final EnumProjectType type;
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
      type: EnumProjectTypeX.fromText(data[EnumProject.type.value]),
      status: EnumProjectStatusX.fromText(data[EnumProject.status.value]),
      createdBy: data[EnumProject.createdBy.value],
      totalContribut: data[EnumProject.totalContribut.value],
      start: HelperDateConvert.toDateTime(data[EnumProject.start.value]),
      end: HelperDateConvert.toDateTime(data[EnumProject.end.value]),
    );
  }

  factory ModelProject.fromDrift(Map<String, dynamic> data) {
    return ModelProject(
      createdAt: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumProject.createdAt.name]),
      ),
      workspaceId: data[EnumProject.workspaceId.name],
      id: data[EnumProject.id.name],
      name: data[EnumProject.name.name],
      type: EnumProjectTypeX.fromText(data[EnumProject.type.name]),
      status: EnumProjectStatusX.fromText(data[EnumProject.status.name]),
      createdBy: data[EnumProject.createdBy.name],
      totalContribut: data[EnumProject.totalContribut.name],
      start: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumProject.start.name]),
      ),
      end: HelperDateConvert.toDateTime(
        DateTime.fromMillisecondsSinceEpoch(data[EnumProject.end.name]),
      ),
    );
  }

  ModelProject copyWith({
    String? id,
    String? name,
    EnumProjectType? type,
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
      EnumProject.start.value: HelperDateConvert.toJsonISO(start),
      EnumProject.end.value: HelperDateConvert.toJsonISO(end),
      EnumProject.status.value: status.text,
      EnumProject.createdBy.value: createdBy,
      EnumProject.totalContribut.value: totalContribut,
      EnumProject.type.value: type.text,
      EnumProject.workspaceId.value: workspaceId,
    };
  }

  static ModelProject createProject({
    required String name,
    required DateTime start,
    required DateTime end,
    required DateTime createdAt,
    required int totalContribut,
    required EnumProjectType type,
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
