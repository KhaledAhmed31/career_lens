import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/repositories/skill_search_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SearchForSkillUseCase {
  final SkillSearchRepo _skillSearchRepo;
  SearchForSkillUseCase(this._skillSearchRepo);
  Future<Result<List<SkillEntity>>> call() => _skillSearchRepo.getSkills();
}
