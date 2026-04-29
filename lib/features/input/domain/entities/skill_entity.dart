import 'package:equatable/equatable.dart';

class SkillEntity extends Equatable {
  final String name;
  final int percentage;

  const SkillEntity({
    required this.name,
    required this.percentage,
  });

  @override
  List<Object> get props => [name, percentage];

  @override
  String toString() => 'SkillEntity(name: $name, percentage: $percentage)';
}