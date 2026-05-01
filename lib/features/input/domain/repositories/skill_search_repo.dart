import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';

abstract class SkillSearchRepo {
  Future<Result<List<SkillEntity>>> getSkills();
}