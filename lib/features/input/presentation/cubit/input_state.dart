part of 'input_cubit.dart';

class InputState {
  final bool isSearching;
  final bool canBack;
  final BaseState<List<SkillEntity>> storedSkillsState;
  final List<SkillEntity> searchData;
  final Set<SkillEntity> selectedSkill;
  final Set<SkillEntity> checkedSkills;
  final List<SkillEntity> filteredSkill;
  const InputState({
    this.storedSkillsState = const BaseState.initial(),
    this.searchData = const [],
    this.selectedSkill = const {},
    this.checkedSkills = const {},
    this.filteredSkill = const [],
    this.isSearching = false,
    this.canBack = false,
  });

  InputState copyWith({
    BaseState<List<SkillEntity>>? storedSkillsState,
    List<SkillEntity>? searchData,
    Set<SkillEntity>? selectedSkill,
    Set<SkillEntity>? checkedSkills,
    List<SkillEntity>? filteredSkill,
    bool? isSearching,
    bool? canBack,
  }) {
    return InputState(
      storedSkillsState: storedSkillsState ?? this.storedSkillsState,
      searchData: searchData ?? this.searchData,
      selectedSkill: selectedSkill ?? this.selectedSkill,
      filteredSkill: filteredSkill ?? this.filteredSkill,
      checkedSkills: checkedSkills ?? {},
      isSearching: isSearching ?? this.isSearching,
      canBack: canBack ?? this.canBack,
    );
  }
}
