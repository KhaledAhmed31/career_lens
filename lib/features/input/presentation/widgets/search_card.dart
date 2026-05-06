import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({super.key, required this.title});
  final String title;

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
                getIt<InputCubit>().doIntent(
                  isChecked
                      ? AddToCheckedSkills(
                          skill: SkillEntity(
                            name: widget.title,
                            proficiency: 0,
                          ),
                        )
                      : RemoveFromCheckedSkills(skillName: widget.title),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
