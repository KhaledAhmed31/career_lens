import 'dart:developer';

import 'package:career_lens/core/config/base_state/base_state.dart';
import 'package:career_lens/core/config/errors/failure.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/usecases/search_for_skill_use_case.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'input_state.dart';

@lazySingleton
class InputCubit extends Cubit<InputState> {
  final GetAllSkillSUseCase getallSkillUseCase;
  InputCubit({required this.getallSkillUseCase}) : super(InputState());

  void doIntent(InputEvent intent) {
    log('Intent: $intent');
    intent.when(
      searchForSkill: _searchForSkill,
      fetchUserSkills: _fetchUserSkills,
    );
  }

  void _searchForSkill(String query) async {
    emit(state.copyWith(skillSearchState: BaseState.loading()));
    await _getAllSkills();
    final filteredSkills =
        state.allSkills.data
            ?.where((skill) => skill.name.contains(query.toLowerCase()))
            .toList() ??
        [];
    emit(state.copyWith(skillSearchState: BaseState.success(filteredSkills)));
  }

  Future<void> _getAllSkills() async {
    if (state.allSkills.data == null ||
        state.allSkills.state != StateType.initial ||
        state.allSkills.state != StateType.error) {
      return;
    }
    emit(state.copyWith(allSkills: BaseState.loading()));
    final result = await getallSkillUseCase.call();
    result.when(
      success: (skills) =>
          emit(state.copyWith(allSkills: BaseState.success(skills))),
      error: (errorMessage) => emit(
        state.copyWith(
          allSkills: BaseState.error(
            Failure(errorMessage ?? 'Unknown error occurred'),
          ),
        ),
      ),
    );
  }

  void _fetchUserSkills() async {
    emit(state.copyWith(userSkillsState: BaseState.loading()));
    try {
      // Simulate fetching user skills
      await Future.delayed(Duration(seconds: 2));
      List<SkillEntity> skills = [
        SkillEntity(name: 'Flutter', proficiency: 4),
        SkillEntity(name: 'Dart', proficiency: 3),
      ];
      emit(state.copyWith(userSkillsState: BaseState.success(skills)));
    } catch (e) {
      emit(
        state.copyWith(
          userSkillsState: BaseState.error(
            Failure('Failed to fetch user skills'),
          ),
        ),
      );
    }
  }
}
