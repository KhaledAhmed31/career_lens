import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/repositories/user_skills_repo.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class AddSkillsUseCase {
  final UserSkillsRepo _userSkillsRepo;

  AddSkillsUseCase(this._userSkillsRepo);
  Future<void> call({required List<SkillEntity> skill}) async => await _userSkillsRepo.addSkill(skill: skill);
}