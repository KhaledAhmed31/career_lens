part of 'input_cubit.dart';

class InputState extends Equatable {
  final BaseState<List<SkillEntity>> userSkillsState;
  final BaseState<List<SkillEntity>> skillSearchState;
  final BaseState<List<SkillEntity>> allSkills;
  const InputState({
    this.userSkillsState = const BaseState.initial(),
    this.skillSearchState = const BaseState.initial(),
    this.allSkills = const BaseState.initial(),
  });
  @override
  List<Object> get props => [userSkillsState, skillSearchState, allSkills];

  InputState copyWith({
    BaseState<List<SkillEntity>>? userSkillsState,
    BaseState<List<SkillEntity>>? skillSearchState,
    BaseState<List<SkillEntity>>? allSkills,
  }) {
    return InputState(
      userSkillsState: userSkillsState ?? this.userSkillsState,
      skillSearchState: skillSearchState ?? this.skillSearchState,
      allSkills: allSkills ?? this.allSkills,
    );
  }
}
