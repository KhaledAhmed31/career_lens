import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/repositories/user_skills_repo.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetUserSkillsUseCase {
  final UserSkillsRepo _dataSource;

  GetUserSkillsUseCase(this._dataSource);

  Future<Result<List<SkillEntity>>> call() async =>
      await _dataSource.getUserSkills();
}
