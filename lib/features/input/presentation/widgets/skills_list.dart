import 'package:career_lens/core/config/base_state/base_state.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/widgets/search_card.dart';
import 'package:career_lens/features/input/presentation/widgets/skill_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkillsList extends StatelessWidget {
  const SkillsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        if (state.isSearching) {
          if (state.skillSearchState.state == StateType.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.skillSearchState.state == StateType.error) {
            return Center(
              child: Text(
                state.skillSearchState.exception?.message ?? 'Error occurred',
              ),
            );
          } else if (state.skillSearchState.state == StateType.success) {
            final skills = state.skillSearchState.data ?? [];
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
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return SkillCard(
              title: state.userSkillsState.data!.elementAt(index).name,
              value: state.userSkillsState.data!
                  .elementAt(index)
                  .proficiency
                  .toDouble(),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 12);
          },
          itemCount: state.userSkillsState.data?.length ?? 0,
        );
      },
    );
  }
}
