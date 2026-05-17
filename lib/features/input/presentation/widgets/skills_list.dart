import 'dart:developer';

import 'package:career_lens/core/config/base_state/base_state.dart';
import 'package:career_lens/core/ui/colors/app_colors.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:career_lens/features/input/presentation/widgets/search_card.dart';
import 'package:career_lens/features/input/presentation/widgets/skill_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SkillsList extends StatefulWidget {
  const SkillsList({super.key});

  @override
  State<SkillsList> createState() => _SkillsListState();
}

class _SkillsListState extends State<SkillsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        log("item should be deleted==============================");
        if (state.storedSkillsState.state == StateType.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isSearching) {
          final skills = state.filteredSkill;
          if (skills.isEmpty) {
            return const Center(child: Text('No skills found'));
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return SearchCard(title: skills[index].name);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 12);
            },
            itemCount: skills.length,
          );
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            // Convert to list once, stable order guaranteed
            final skillsList = state.selectedSkill.toList();
            final skill =
                skillsList[index]; // capture now, not inside onPressed

            return Slidable(
              key: ValueKey(skill.name), // ValueKey is more explicit
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: .25,
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(8),
                    onPressed: (_) => context.read<InputCubit>().doIntent(
                      RemoveSkill(
                        skill: SkillEntity(
                          name: skill.name, // ✅ captured, not re-evaluated
                          proficiency: skill.proficiency,
                        ),
                      ),
                    ),
                    backgroundColor: AppColors.weak,
                    icon: Icons.delete,
                    spacing: 16,
                  ),
                ],
              ),
              child: SkillCard(
                title: skill.name,
                value: skill.proficiency.toDouble(),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 12);
          },
          itemCount: state.selectedSkill.length,
        );
      },
    );
  }
}
