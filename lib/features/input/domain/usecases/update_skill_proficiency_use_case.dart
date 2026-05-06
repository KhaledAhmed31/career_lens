import 'package:career_lens/features/input/domain/repositories/user_skills_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateSkillProficiencyUseCase {
  final UserSkillsRepo _userSkillsRepo;

  UpdateSkillProficiencyUseCase(this._userSkillsRepo);
  Future<void> call({
    required String skillName,
    required int proficiency,
  }) async => await _userSkillsRepo.updateSkillProficiency(
    skillName: skillName,
    proficiency: proficiency,
  );
}
