import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/core/shared/widgets/custom_button.dart';
import 'package:career_lens/core/shared/widgets/custom_scaffold.dart';
import 'package:career_lens/core/shared/widgets/content_card.dart';
import 'package:career_lens/core/utils/const/app_strings.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:career_lens/features/input/presentation/widgets/add_skill_section.dart';
import 'package:career_lens/features/input/presentation/widgets/skills_list.dart';
import 'package:career_lens/features/input/presentation/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocProvider(
        create: (context) =>
            getIt<InputCubit>()..doIntent(SearchSkills(query: 'f')),
        child: ContentCard(
          content: [
            ...titleSection(
              context,
              AppStrings.inputScreenTitle,
              AppStrings.inputScreenDescription,
            ),
            SizedBox(height: 30.0),
            AddSkillSection(),
            SizedBox(height: 12),
            Expanded(child: SkillsList()),
            CustomButton(
              text: AppStrings.sendButtonText,
              padding: 60,
              onPressed: () {
                getIt<InputCubit>().doIntent(SearchSkills(query: 'flutter'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
