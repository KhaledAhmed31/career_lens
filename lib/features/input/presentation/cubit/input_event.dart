import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:equatable/equatable.dart';

sealed class InputEvent extends Equatable {
  const InputEvent();
  @override
  List<Object> get props => [];

  void when({
    required void Function(String query) searchForSkill,
    required void Function() fetchUserSkills,
    required void Function(SkillEntity skill) addToCheckedSkills,
    required void Function() addSkills,
    required void Function(String skillName) removeSkill,
    required void Function(String skillName, int proficiency) updateSkillProficiency,
    required void Function(String skillName) removeFromCheckedSkills

  }) {
    if (this is SearchSkills) {
      searchForSkill((this as SearchSkills).query);
    } else if (this is FetchUserSkills) {
      fetchUserSkills();
    } else if (this is AddToCheckedSkills){
      addToCheckedSkills((this as AddToCheckedSkills).skill);
    } else if (this is AddSkills){
      addSkills();
    } else if (this is RemoveSkill){
      removeSkill((this as RemoveSkill).skillName);
    } else if (this is UpdateSkillProficiency){
      final event = this as UpdateSkillProficiency;
      updateSkillProficiency(event.skillName, event.proficiency);
    } else if (this is RemoveFromCheckedSkills){
      removeSkill((this as RemoveFromCheckedSkills).skillName);
    }
  }
}

class FetchUserSkills extends InputEvent {}

class AddToCheckedSkills extends InputEvent {
  final SkillEntity skill;

  const AddToCheckedSkills({required this.skill});

  @override
  List<Object> get props => [skill];
}
class AddSkills extends InputEvent {

  const AddSkills();

}

class RemoveFromCheckedSkills extends InputEvent {
  final String skillName;

  const RemoveFromCheckedSkills({required this.skillName});

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
