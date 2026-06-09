import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';
import 'package:task_manager/shared/helper/helper_date/helper_date_convert/helper_date_convert.dart';

class ModelProject extends Equatable {
  final String projectId;
  final String projectName;
  final String projectType;
  final EnumProjectStatus projectStatus;
  final String projectCreatedBy;
  final String projectCreatedId;
  final int projectTotalContribut;
  final DateTime projectStart;
  final DateTime projectEnd;

  const ModelProject({
    required this.projectId,
    required this.projectName,
    required this.projectType,
    required this.projectStatus,
    required this.projectCreatedBy,
    required this.projectCreatedId,
    required this.projectTotalContribut,
    required this.projectStart,
    required this.projectEnd,
  });

  factory ModelProject.fromJson(Map<String, dynamic> data) {
    return ModelProject(
      projectId: data[EnumProject.projectId.value],
      projectName: data[EnumProject.projectName.value],
      projectType: data[EnumProject.projectType.value],
      projectStatus: EnumProjectStatusX.fromText(
        data[EnumProject.projectStatus.value],
      ),
      projectCreatedBy: data[EnumProject.projectCreatedBy.value],
      projectCreatedId: data[EnumProject.projectCreatedId.value],
      projectTotalContribut: data[EnumProject.projectTotalContribut.value],
      projectStart: HelperDateConvert.toDateTime(
        data[EnumProject.projectStart.value],
      ),
      projectEnd: HelperDateConvert.toDateTime(
        data[EnumProject.projectEnd.value],
      ),
    );
  }

  @override
  List<Object?> get props => [
    projectId,
    projectName,
    projectType,
    projectStatus,
    projectCreatedBy,
    projectCreatedId,
    projectTotalContribut,
    projectStart,
    projectEnd,
  ];
}
