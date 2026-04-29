import 'package:career_lens/core/shared/widgets/custom_button.dart';
import 'package:career_lens/core/shared/widgets/custom_textfield.dart';
import 'package:career_lens/core/utils/const/app_strings.dart';
import 'package:flutter/material.dart';

class AddSkillSection extends StatelessWidget {
  const AddSkillSection({super.key});

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
            child: CustomTextfield(hint: AppStrings.textFieldHint),
          ),
          const SizedBox(width: 4.0),
          CustomButton(onPressed: () {}, text: 'Add', padding: 24.0),
        ],
      ),
    );
  }
}
