import 'dart:convert';
import 'dart:developer';

import 'package:career_lens/features/input/data/models/skill_model.dart';

class AppJson {
  const AppJson._();
  static const String skills = 'assets/json/skills.json';
  static const String skillsKey = 'skill_ids';
  static List<SkillModel> parseSkills(String response) {
    final jsonData = jsonDecode(response);
    return (jsonData[skillsKey] as List<dynamic>)
        .map((skill) => SkillModel(name: skill, proficiency: 0))
        .toList();
  }

  static List<SkillModel> decodeSkills(String response) {
    Map<String, dynamic> jsonData = jsonDecode(response);
    return (jsonData[skillsKey])
        .map<SkillModel>(
          (skillData) => SkillModel(
            name: skillData['name'],
            proficiency: skillData['proficiency'],
          ),
        )
        .toList();
  }

  static String encodeSkills(List<SkillModel> skills) {
    List<Map<String, dynamic>> skillData = skills
        .map((skill) => {'name': skill.name, 'proficiency': skill.proficiency})
        .toList();
    Map<String, dynamic> jsonData = {skillsKey: skillData};
    return jsonEncode(jsonData);
  }
}
