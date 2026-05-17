import 'dart:async';
import 'dart:developer';

import 'package:career_lens/core/config/base_state/base_state.dart';
import 'package:career_lens/core/config/errors/failure.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/domain/usecases/add_skills_use_case.dart';
import 'package:career_lens/features/input/domain/usecases/get_user_skills_use_case.dart';
import 'package:career_lens/features/input/domain/usecases/remove_user_skill_use_case.dart';
import 'package:career_lens/features/input/domain/usecases/search_for_skill_use_case.dart';
import 'package:career_lens/features/input/domain/usecases/update_skill_proficiency_use_case.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'input_state.dart';

@lazySingleton
class InputCubit extends Cubit<InputState> {
  final GetSkillsListForSearchUseCase getSearchSkillsList;
  final RemoveUserSkillUseCase removeUserSkillUseCase;
  final GetUserSkillsUseCase getUserSkillsUseCase;
  final AddSkillsUseCase addSkillsUseCase;
  final UpdateSkillProficiencyUseCase updateSkillProficiencyUseCase;
  Timer? _debounceTimer;
  InputCubit({
    required this.getSearchSkillsList,
    required this.getUserSkillsUseCase,
    required this.addSkillsUseCase,
    required this.updateSkillProficiencyUseCase,
    required this.removeUserSkillUseCase,
  }) : super(InputState());

  void doIntent(InputEvent intent) {
    log('Intent: $intent');
    intent.when(
      searchForSkill: _searchForSkill,
      fetchUserSkills: _getStoredSkills,
      addToCheckSkills: _addToCheckList,
      addSkills: _addToSelectedList,
      removeSkill: _removeUserSkill,
      updateSkillProficiency: _updateProficiency,
      removeFromCheckedSkills: _removeFromCheckedList,
      cancelSearch: _cancleSearch,
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _cancleSearch() => emit(state.copyWith(isSearching: false));

  Future<void> _getStoredSkills() async {
    emit(state.copyWith(storedSkillsState: BaseState.loading()));
    final result = await getUserSkillsUseCase.call();
    result.when(
      success: (skills) {
        emit(
          state.copyWith(
            storedSkillsState: BaseState.success(skills),
            selectedSkill: skills!.toSet(),
          ),
        );
        log("Stored Skills: $skills");
      },
      error: (errorMessage) => emit(
        state.copyWith(
          storedSkillsState: BaseState.error(
            Failure(errorMessage ?? "Something went wrong"),
          ),
        ),
      ),
    );
  }

  Future<List<SkillEntity>> _getSearchDataList() async {
    final searchList = await getSearchSkillsList.call();
    return searchList.when(
      success: (data) => data!,
      error: (errorMessage) => [],
    );
  }

  Future<void> _searchForSkill(String skill) async {
    emit(state.copyWith(isSearching: true));
    _debounceTimer?.cancel();
    if (skill.isEmpty) {
      emit(state.copyWith(filteredSkill: [], isSearching: false));
      return;
    }
    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      List<SkillEntity> searchList = state.searchData;
      if (state.searchData.isEmpty) {
        searchList = await _getSearchDataList();
      }
      emit(
        state.copyWith(
          searchData: searchList,
          filteredSkill: searchList
              .map((e) => e)
              .where(
                (element) => element.name.contains(skill.trim().toLowerCase()),
              )
              .toList(),
        ),
      );
    });
  }

  Future<void> _addToCheckList(SkillEntity skill) async {
    final skills = state.checkedSkills;
    skills.add(skill);
    emit(state.copyWith(checkedSkills: skills, canBack: false));
  }

  Future<void> _removeFromCheckedList(SkillEntity skill) async {
    final skills = state.checkedSkills;
    skills.removeWhere((element) => element.name == skill.name);
    emit(state.copyWith(checkedSkills: skills, canBack: skills.isEmpty));
  }

  Future<void> _addToSelectedList() async {
    final selectedSkills = state.selectedSkill;
    selectedSkills.addAll(state.checkedSkills);
    emit(
      state.copyWith(
        selectedSkill: selectedSkills,
        isSearching: false,
        filteredSkill: [],
      ),
    );
    addSkillsUseCase.call(skill: state.selectedSkill.toList());
  }

  Future<void> _removeUserSkill(SkillEntity skill) async {
    Set<SkillEntity> selectedSkill = state.selectedSkill
        .where((element) => element.name != skill.name)
        .toSet();
    emit(state.copyWith(selectedSkill: selectedSkill));
    log("Selected Skills: ${state.selectedSkill}");
    removeUserSkillUseCase.call(skillName: skill.name);
  }

  Future<void> _updateProficiency(SkillEntity skill) async {
    await updateSkillProficiencyUseCase.call(
      skillName: skill.name,
      proficiency: skill.proficiency,
    );
    Set<SkillEntity> selectedSkill = state.selectedSkill;
    for (var element in selectedSkill) {
      if (element.name == skill.name) {
        element.proficiency = skill.proficiency;
      }
    }
    emit(state.copyWith(selectedSkill: selectedSkill));
  }
}
