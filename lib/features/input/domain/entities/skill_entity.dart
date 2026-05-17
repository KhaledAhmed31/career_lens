import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class SkillEntity extends Equatable {
   String name;
   int proficiency;

   SkillEntity({
    required this.name,
    required this.proficiency,
  });

  @override
  List<Object> get props => [name, proficiency];

  @override
  String toString() => 'SkillEntity(name: $name, proficiency: $proficiency)';
}