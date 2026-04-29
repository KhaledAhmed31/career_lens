part of 'input_cubit.dart';

class InputState extends Equatable {
  final BaseState<List<SkillEntity>> userSkillsState;
  final BaseState<List<String>> searchResultsState;
  const InputState({
    this.userSkillsState = const BaseState.initial(),
    this.searchResultsState = const BaseState.initial(),
  });
  @override
  List<Object> get props => [userSkillsState, searchResultsState];
}
