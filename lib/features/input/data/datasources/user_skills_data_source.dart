import 'package:career_lens/core/config/base_response/base_response.dart';
import 'package:career_lens/core/utils/const/app_json.dart';
import 'package:career_lens/features/input/data/models/skill_model.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
@singleton
class UserSkillsDataSource {
  final SharedPreferences _prefs;
  UserSkillsDataSource(this._prefs);
  Future<Result<List<SkillModel>>> getUserSkills() async{
    try{
      final String? skillsString = _prefs.getString(AppJson.skillsKey);
      if(skillsString == null){
        return const Success(data: []);
      }
      final List<SkillModel> skills = await compute(
        AppJson.decodeSkills,
        skillsString,
      );
    return Success(data: skills);
    }
    catch(e){
      return Error(errorMessage: e.toString());
    }
    
  }
  Future<void> addSkill({required List<SkillModel> skill}){
    final String? skillsString = _prefs.getString(AppJson.skillsKey);
    List<SkillModel> skills = [];
    if(skillsString != null){
      skills = AppJson.decodeSkills(skillsString);
    }
    skills.addAll(skill);
    return _prefs.setString(AppJson.skillsKey, AppJson.encodeSkills(skills));
  }
  Future<void> updateSkillProficiency({required String skillName, required int proficiency}) async {
    final String? skillsString = _prefs.getString(AppJson.skillsKey);
    if (skillsString != null) {
      List<SkillModel> skills = AppJson.decodeSkills(skillsString);
      for (var skill in skills) {
        if (skill.name == skillName) {
          skill.proficiency = proficiency;
          break;
        }
      }
      await _prefs.setString(AppJson.skillsKey, AppJson.encodeSkills(skills));
    }
  }
}