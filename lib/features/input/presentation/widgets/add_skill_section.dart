import 'dart:developer';

import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/core/shared/widgets/custom_button.dart';
import 'package:career_lens/core/shared/widgets/custom_textfield.dart';
import 'package:career_lens/core/utils/const/app_strings.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSkillSection extends StatefulWidget {
  const AddSkillSection({super.key});

  @override
  State<AddSkillSection> createState() => _AddSkillSectionState();
}

class _AddSkillSectionState extends State<AddSkillSection> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 247,
            height: 36,
            child: CustomTextfield(
              hint: AppStrings.textFieldHint,
              onChange: (p0) {
                getIt<InputCubit>().doIntent(SearchForSkills(query: p0));
              },
              controller: _controller,
            ),
          ),
          const SizedBox(width: 4.0),
          BlocSelector<InputCubit, InputState, bool>(
            builder: (BuildContext context, state) {
              log("section updated=====================");
              return CustomButton(
                onPressed: () {
                  if (state) {
                    getIt<InputCubit>().doIntent(CancelSearch());
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                    return;
                  }
                  getIt<InputCubit>().doIntent(AddToSelectedSkills());
                  FocusScope.of(context).unfocus();
                  _controller.clear();
                },
                text: (state && getIt<InputCubit>().state.isSearching)
                    ? AppStrings.backButtonText
                    : AppStrings.addButtonText,
                padding: 24.0,
              );
            },
            selector: (InputState state) {
              return state.canBack;
            },
          ),
        ],
      ),
    );
  }
}
