import 'package:equatable/equatable.dart';
import 'package:task_manager/shared/enum.dart';

class ModelLabel extends Equatable {
  final String id;
  final String name;
  final String color;

  const ModelLabel({required this.id, required this.name, required this.color});

  factory ModelLabel.fromJson(Map<String, dynamic> data) {
    return ModelLabel(
      id: data[EnumLabel.id.value],
      name: data[EnumLabel.name.value],
      color: data[EnumLabel.color.value],
    );
  }

  ModelLabel copyWith({String? id, String? name, String? color}) {
    return ModelLabel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, name, color];
}
