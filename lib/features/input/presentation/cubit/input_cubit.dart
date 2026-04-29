import 'package:career_lens/core/config/base_state/base_state.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  InputCubit() : super(InputState());
}
