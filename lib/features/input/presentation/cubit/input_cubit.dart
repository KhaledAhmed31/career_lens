import 'dart:async';
import 'dart:developer';

import 'package:career_lens/core/config/base_state/base_state.dart';
import 'package:career_lens/core/config/errors/failure.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/usecases/add_skills_use_case.dart';
import 'package:career_lens/features/input/domain/usecases/get_user_skills_use_case.dart';
import 'package:career_lens/features/input/domain/usecases/search_for_skill_use_case.dart';
import 'package:career_lens/features/input/domain/usecases/update_skill_proficiency_use_case.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'input_state.dart';

@lazySingleton
class InputCubit extends Cubit<InputState> {
  final SearchForSkillUseCase getallSkillUseCase;
  final GetUserSkillsUseCase getUserSkillsUseCase;
  final AddSkillsUseCase addSkillsUseCase;
  final UpdateSkillProficiencyUseCase updateSkillProficiencyUseCase;
  Timer? _debounceTimer;
  InputCubit({
    required this.getallSkillUseCase,
    required this.getUserSkillsUseCase,
    required this.addSkillsUseCase,
    required this.updateSkillProficiencyUseCase,
  }) : super(InputState());

  void doIntent(InputEvent intent) {
    log('Intent: $intent');
    intent.when(
      searchForSkill: _searchForSkill,
      fetchUserSkills: _getUserSkills,
      addToCheckedSkills: _addToCheckedSkills,
      addSkills: _addSkill,
      removeFromCheckedSkills: _removeFromCheckedSkills,
      removeSkill: (_) {},
      updateSkillProficiency: _updateSkillProficiency,
    );
  }

  Future<void> _updateSkillProficiency(
    String skillName,
    int proficiency,
  ) async {
    await updateSkillProficiencyUseCase.call(
      skillName: skillName,
      proficiency: proficiency,
    );
    _getUserSkills();
  }

  void _addToUserSkills(List<SkillEntity> skill) async {
    await addSkillsUseCase.call(skill: skill);
  }

  void _addSkill() async {
    emit(
      state.copyWith(
        userSkillsState: BaseState.success([
          ...?state.userSkillsState.data,
          ...state.checkedSkills,
        ]),
        selectedSkill: [...state.selectedSkill, ...state.checkedSkills],
      ),
    );
    _clearSearch();
    _addToUserSkills(state.checkedSkills);
  }

  void _addToCheckedSkills(SkillEntity skill) {
    emit(state.copyWith(checkedSkills: [...state.checkedSkills, skill]));
  }

  void _clearSearch() {
    emit(
      state.copyWith(
        skillSearchState: const BaseState.initial(),
        isSearching: false,
      ),
    );
  }

  void _searchForSkill(String query) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        _clearSearch();
        return;
      }
      emit(
        state.copyWith(
          skillSearchState: BaseState.loading(),
          isSearching: true,
        ),
      );
      await _getAllSkills();
      final filteredSkills =
          state.allSkills.data
              ?.where(
                (skill) => skill.name.toLowerCase().contains(
                  query.trim().toLowerCase(),
                ),
              )
              .toList() ??
          [];
      emit(state.copyWith(skillSearchState: BaseState.success(filteredSkills)));
    });
  }

  Future<void> _getAllSkills() async {
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

  void _getUserSkills() async {
    emit(state.copyWith(userSkillsState: BaseState.loading()));
    final result = await getUserSkillsUseCase.call();
    result.when(
      success: (skills) {
        emit(
          state.copyWith(
            userSkillsState: BaseState.success(skills),
            selectedSkill: skills,
          ),
        );
        log('User skills fetched: ${skills?.length} skills');
      },
      error: (errorMessage) {
        emit(
          state.copyWith(
            userSkillsState: BaseState.error(
              Failure(errorMessage ?? 'Unknown error occurred'),
            ),
          ),
        );
      },
    );
  }

  void _removeFromCheckedSkills(String skillName) {
    emit(
      state.copyWith(
        checkedSkills: state.checkedSkills
            .where((skill) => skill.name != skillName)
            .toList(),
      ),
    );
  }
}
