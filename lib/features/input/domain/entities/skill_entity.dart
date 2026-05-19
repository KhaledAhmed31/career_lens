import 'package:equatable/equatable.dart';

class SkillEntity extends Equatable {
  final String name;
  final int proficiency;

  const SkillEntity({required this.name, required this.proficiency});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'SkillEntity(name: $name, proficiency: $proficiency)';
}
