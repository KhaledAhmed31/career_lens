import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/features/input/data/datasources/user_skills_data_source.dart';
import 'package:career_lens/features/input/data/models/skill_model.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/repositories/user_skills_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserSkillsRepo)
class UserSkillsRepoImpl implements UserSkillsRepo {
  final UserSkillsDataSource _dataSource;

  UserSkillsRepoImpl(this._dataSource);

  @override
  Future<Result<List<SkillEntity>>> getUserSkills() {
    return _dataSource.getUserSkills().then((result) {
      return result.when(
        success: (skills) => Success(
          data: (skills ?? [])
              .map(
                (skill) => SkillEntity(
                  name: skill.name,
                  proficiency: skill.proficiency ?? 0,
                ),
              )
              .toList(),
        ),
        error: (errorMessage) => Error(errorMessage: errorMessage),
      );
    });
  }

  @override
  Future<void> addSkill({required List<SkillEntity> skill}) {
    final skillModels = skill
        .map((s) => SkillModel(name: s.name, proficiency: s.proficiency))
        .toList();
    return _dataSource.addSkill(skill: skillModels);
  }

  @override
  void removeSkill({required String skillName}) =>
      _dataSource.removeSkill(skillName: skillName);
      
  @override
  Future<void> updateSkillProficiency({
    required String skillName,
    required int proficiency,
  }) {
    return _dataSource.updateSkillProficiency(
      skillName: skillName,
      proficiency: proficiency,
    );
  }
}
