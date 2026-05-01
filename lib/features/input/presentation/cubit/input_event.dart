import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:equatable/equatable.dart';

sealed class InputEvent extends Equatable {
  const InputEvent();
  @override
  List<Object> get props => [];

  void when({
    required void Function(String query) searchForSkill,
    required void Function() fetchUserSkills,
  }) {
    if (this is SearchSkills) {
      searchForSkill((this as SearchSkills).query);
    } else if (this is FetchUserSkills) {
      fetchUserSkills();
    }
  }
}

class FetchUserSkills extends InputEvent {}

class AddSkill extends InputEvent {
  final String skillName;

  const AddSkill({required this.skillName});

  @override
  List<Object> get props => [skillName];
}

class RemoveSkill extends InputEvent {
  final String skillName;

  const RemoveSkill({required this.skillName});

  @override
  List<Object> get props => [skillName];
}

class UpdateSkillProficiency extends InputEvent {
  final String skillName;
  final int proficiency;

  const UpdateSkillProficiency({
    required this.skillName,
    required this.proficiency,
  });

  @override
  List<Object> get props => [skillName, proficiency];
}

class SearchSkills extends InputEvent {
  final String query;

  const SearchSkills({required this.query});

  @override
  List<Object> get props => [query];
}

class SendData extends InputEvent {
  final List<SkillEntity> skills;

  const SendData({required this.skills});

  @override
  List<Object> get props => [skills];
}
