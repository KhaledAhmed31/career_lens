import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';

abstract class UserSkillsRepo {
  Future<Result<List<SkillEntity>>> getUserSkills();
  Future<void> addSkill({required List<SkillEntity> skill});
  void removeSkill({required String skillName});
  Future<void> updateSkillProficiency({
    required String skillName,
    required int proficiency,
  });
}
