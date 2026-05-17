import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/features/input/data/datasources/skill_search_data_source.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/repositories/skill_search_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: SkillSearchRepo)
class SkillSearchRepoImpl implements SkillSearchRepo {
  final SkillSearchDataSource _dataSource;
  SkillSearchRepoImpl(this._dataSource);
  @override
  Future<Result<List<SkillEntity>>> getSkillsListForSearch() async {
    final result = await _dataSource.getAllSkills();
    return result.when(
      success: (skills) => Success(
        data: (skills ?? [])
            .map(
              (skill) => SkillEntity(
                proficiency: skill.proficiency ?? 0,
                name: skill.name,
              ),
            )
            .toList(),
      ),
      error: (errorMessage) => Error(errorMessage: errorMessage),
    );
  }
}
