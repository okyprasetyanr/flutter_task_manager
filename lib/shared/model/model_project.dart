import 'package:equatable/equatable.dart';
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

  const ModelProject({
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
