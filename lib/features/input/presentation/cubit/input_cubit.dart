import 'package:career_lens/core/config/base_state/base_state.dart';
import 'package:career_lens/core/config/errors/failure.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  InputCubit() : super(InputState());

  void fetchUserSkills() async {
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
