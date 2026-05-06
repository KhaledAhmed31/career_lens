part of 'input_cubit.dart';

class InputState extends Equatable {
  final BaseState<List<SkillEntity>> userSkillsState;
  final BaseState<List<SkillEntity>> skillSearchState;
  final BaseState<List<SkillEntity>> allSkills;
  final List<SkillEntity> selectedSkill;
  final List<SkillEntity> checkedSkills;
  final List<SkillEntity> filteredSkill;
  final bool isSearching;
  const InputState({
    this.userSkillsState = const BaseState.initial(),
    this.skillSearchState = const BaseState.initial(),
    this.allSkills = const BaseState.initial(),
    this.selectedSkill = const [],
    this.checkedSkills = const [],
    this.filteredSkill = const [],
    this.isSearching = false,
  });
  @override
  List<Object> get props => [
    userSkillsState,
    skillSearchState,
    allSkills,
    selectedSkill,
    filteredSkill,
    isSearching,
    checkedSkills,
  ];

  InputState copyWith({
    BaseState<List<SkillEntity>>? userSkillsState,
    BaseState<List<SkillEntity>>? skillSearchState,
    BaseState<List<SkillEntity>>? allSkills,
    List<SkillEntity>? selectedSkill,
    List<SkillEntity>? filteredSkill,
    bool? isSearching,
    List<SkillEntity>? checkedSkills,
  }) {
    return InputState(
      userSkillsState: userSkillsState ?? this.userSkillsState,
      skillSearchState: skillSearchState ?? this.skillSearchState,
      allSkills: allSkills ?? this.allSkills,
      selectedSkill: selectedSkill ?? this.selectedSkill,
      filteredSkill: filteredSkill ?? this.filteredSkill,
      isSearching: isSearching ?? this.isSearching,
      checkedSkills: checkedSkills ?? this.checkedSkills,
    );
  }
}
