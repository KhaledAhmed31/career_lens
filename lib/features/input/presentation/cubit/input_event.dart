import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:equatable/equatable.dart';

sealed class InputEvent extends Equatable {
  const InputEvent();
  @override
  List<Object> get props => [];

  void when({
    required void Function(String query) searchForSkill,
    required void Function() fetchUserSkills,
    required void Function(SkillEntity skill) addToCheckSkills,
    required void Function() addSkills,
    required void Function(SkillEntity skillName) removeSkill,
    required void Function(SkillEntity skill) updateSkillProficiency,
    required void Function(SkillEntity skill) removeFromCheckedSkills,
    required void Function() cancelSearch,
  }) {
    if (this is SearchForSkills) {
      searchForSkill((this as SearchForSkills).query);
    } else if (this is FetchUserSkills) {
      fetchUserSkills();
    } else if (this is AddToCheckedSkills) {
      addToCheckSkills((this as AddToCheckedSkills).skill);
    } else if (this is AddToSelectedSkills) {
      addSkills();
    } else if (this is RemoveSkill) {
      removeSkill((this as RemoveSkill).skill);
    } else if (this is UpdateSkillProficiency) {
      final event = this as UpdateSkillProficiency;
      updateSkillProficiency(event.skill);
    } else if (this is RemoveFromCheckedSkills) {
      removeFromCheckedSkills((this as RemoveFromCheckedSkills).skill);
    } else if (this is CancelSearch) {
      cancelSearch();
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

class AddToSelectedSkills extends InputEvent {
  const AddToSelectedSkills();
}

class RemoveFromCheckedSkills extends InputEvent {
  final SkillEntity skill;

  const RemoveFromCheckedSkills({required this.skill});

  @override
  List<Object> get props => [skill];
}

class RemoveSkill extends InputEvent {
  final SkillEntity skill;

  const RemoveSkill({required this.skill});

  @override
  List<Object> get props => [skill];
}

class UpdateSkillProficiency extends InputEvent {
  final SkillEntity skill;

  const UpdateSkillProficiency({required this.skill});

  @override
  List<Object> get props => [skill];
}

class SearchForSkills extends InputEvent {
  final String query;

  const SearchForSkills({required this.query});

  @override
  List<Object> get props => [query];
}
class CancelSearch extends InputEvent {}
