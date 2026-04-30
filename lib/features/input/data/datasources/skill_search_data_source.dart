import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/core/config/errors/app_exception.dart';
import 'package:career_lens/core/utils/const/app_json.dart';
import 'package:career_lens/features/input/data/datasources/skill_data_source.dart';
import 'package:career_lens/features/input/data/models/skill_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@Named('search')
@Singleton(as: SkillDataSource)
class SkillSearchDataSource implements SkillDataSource {
  Future<Result<List<SkillModel>>> searchSkills({required String query}) async {
    try {
      final response = await rootBundle.loadString(AppJson.skills);
      final List<SkillModel> skills = await compute(
        AppJson.parseSkills,
        response,
      );

      return Success(
        data: skills
            .where((skill) => skill.name.contains(query.toLowerCase()))
            .toList(),
      );
    } catch (e) {
      return Error(exception: e as AppException);
    }
  }
}
