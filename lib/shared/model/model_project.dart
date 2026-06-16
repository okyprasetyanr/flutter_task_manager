import 'package:equatable/equatable.dart';
import 'package:task_manager/feature/shared_component/user/domain/model/model_user.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelProject extends Equatable {
  final String id;
  final String name;
  final String type;
  final EnumProjectStatus status;
  final String createdId;
  final int totalContribut;
  final DateTime start;
  final DateTime end;
  final List<ModelUser>? dataMember;

  const ModelProject({
    this.dataMember,
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.createdId,
    required this.totalContribut,
    required this.start,
    required this.end,
  });

  factory ModelProject.fromJson(Map<String, dynamic> data) {
    return ModelProject(
      id: data[EnumProject.id.value],
      name: data[EnumProject.name.value],
      type: data[EnumProject.type.value],
      status: EnumProjectStatusX.fromText(data[EnumProject.status.value]),
      createdId: data[EnumProject.createdId.value],
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
    String? createdId,
    int? totalContribut,
    DateTime? start,
    DateTime? end,
    List<ModelUser>? dataMember,
  }) {
    return ModelProject(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      createdId: createdId ?? this.createdId,
      totalContribut: totalContribut ?? this.totalContribut,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    status,
    createdId,
    totalContribut,
    start,
    end,
  ];
}
