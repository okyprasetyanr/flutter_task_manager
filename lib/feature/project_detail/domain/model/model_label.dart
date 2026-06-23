// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:task_manager/shared/enum.dart';

class ModelLabel extends Equatable {
  final String id;
  final String name;
  final String color;
  final String companyId;

  const ModelLabel({
    required this.id,
    required this.name,
    required this.color,
    required this.companyId,
  });

  factory ModelLabel.fromJson(Map<String, dynamic> data) {
    return ModelLabel(
      companyId: data[EnumLabel.companyId.value],
      id: data[EnumLabel.id.value],
      name: data[EnumLabel.name.value],
      color: data[EnumLabel.color.value],
    );
  }

  factory ModelLabel.fromDrift(Map<String, dynamic> data) {
    return ModelLabel(
      companyId: data[EnumLabel.companyId.name],
      id: data[EnumLabel.id.name],
      name: data[EnumLabel.name.name],
      color: data[EnumLabel.color.name],
    );
  }

  ModelLabel copyWith({
    String? id,
    String? name,
    String? color,
    String? companyId,
  }) {
    return ModelLabel(
      companyId: companyId ?? this.companyId,
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [companyId, id, name, color];
}
