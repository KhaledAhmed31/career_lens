import 'package:career_lens/features/input/domain/repositories/user_skills_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoveUserSkillUseCase {
  final UserSkillsRepo repo;
  RemoveUserSkillUseCase({required this.repo});

  void call({required String skillName}) =>
      repo.removeSkill(skillName: skillName);
}
