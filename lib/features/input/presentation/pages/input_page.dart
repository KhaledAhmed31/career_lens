import 'dart:developer';

import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/core/model/service/career_predictor_service.dart';
import 'package:career_lens/core/routes/route_path.dart';
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
import 'package:go_router/go_router.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocProvider(
        create: (context) => getIt<InputCubit>()..doIntent(FetchUserSkills()),
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
            BlocSelector<InputCubit, InputState, bool>(
              selector: (InputState state) {
                return state.isSearching;
              },
              builder: (BuildContext context, bool isSearching) {
                if (isSearching) {
                  return const SizedBox.shrink();
                }
                return CustomButton(
                  text: AppStrings.sendButtonText,
                  padding: 60,
                  onPressed: () {
                    final skills =
                        context.read<InputCubit>().state.userSkillsState.data ??
                        [];
                    final skillMap = {
                      for (var skill in skills)
                        skill.name: skill.proficiency.toDouble(),
                    };
                    log('Predicting with skills===============: $skillMap');
                    final result = CareerPredictorService.instance.predict(
                      skillMap,
                    );

                    context.push(RoutePath.result, extra: result);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
