import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/core/utils/const/app_json.dart';
import 'package:career_lens/features/input/data/models/skill_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@singleton
class SkillSearchDataSource {
  Future<Result<List<SkillModel>>> getAllSkills() async {
    try {
      final response = await rootBundle.loadString(AppJson.skills);
      final List<SkillModel> skills = AppJson.parseSkills(response);

      return Success(data: skills);
    } catch (e) {
      return Error(errorMessage: e.toString());
    }
  }
}
