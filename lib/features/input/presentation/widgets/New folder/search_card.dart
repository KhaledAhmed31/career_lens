import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _surface  = Color(0xFF131620);
const _border   = Color(0xFF1E2235);
const _accent   = Color(0xFF6C63FF);
const _textPrim = Color(0xFFEEF0FF);
const _textMuted= Color(0xFF6B7280);

class SearchCard extends StatefulWidget {
  final String title;
  const SearchCard({super.key, required this.title});

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard>
    with SingleTickerProviderStateMixin {
  bool _checked = false;
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    _ctrl.reverse().then((_) => _ctrl.forward());
    final next = !_checked;
    setState(() => _checked = next);
    getIt<InputCubit>().doIntent(
      next
          ? AddToCheckedSkills(
              skill: SkillEntity(name: widget.title, proficiency: 0),
            )
          : RemoveFromCheckedSkills(skillName: widget.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _checked ? _accent.withOpacity(0.10) : _surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _checked ? _accent.withOpacity(0.50) : _border,
              width: _checked ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Custom checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: _checked ? _accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _checked ? _accent : _border,
                    width: 1.5,
                  ),
                ),
                child: _checked
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: _checked ? _textPrim : _textMuted,
                    fontSize: 13,
                    fontWeight:
                        _checked ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (_checked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Selected',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
