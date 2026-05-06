import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/core/shared/widgets/custom_button.dart';
import 'package:career_lens/core/shared/widgets/custom_textfield.dart';
import 'package:career_lens/core/utils/const/app_strings.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:flutter/material.dart';

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
                getIt<InputCubit>().doIntent(SearchSkills(query: p0));
                if (p0.isEmpty) _controller.clear();
              },
              controller: _controller,
            ),
          ),
          const SizedBox(width: 4.0),
          CustomButton(
            onPressed: () {
              getIt<InputCubit>().doIntent(AddSkills());
            },
            text: 'Add',
            padding: 24.0,
          ),
        ],
      ),
    );
  }
}
