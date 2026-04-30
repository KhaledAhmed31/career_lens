import 'package:career_lens/features/input/presentation/widgets/skill_card.dart';
import 'package:flutter/material.dart';

class SkillsList extends StatelessWidget {
  const SkillsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return SkillCard(title: "Flutter", value: 20.0 + 10.0);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 12);
      },
      itemCount: 15,
    );
  }
}
