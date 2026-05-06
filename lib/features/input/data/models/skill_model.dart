import 'package:career_lens/features/input/domain/entities/skill_entity.dart';

class SkillModel {
  final String name;
  int? proficiency;
  SkillModel({required this.name, this.proficiency});

  factory SkillModel.fromEntity(SkillEntity entity) {
    return SkillModel(name: entity.name, proficiency: entity.proficiency);
  }
}
