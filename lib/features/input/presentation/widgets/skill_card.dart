import 'dart:async';

import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/core/ui/colors/app_colors.dart';
import 'package:career_lens/features/input/domain/entities/skill_entity.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StrokeThumbShape extends SliderComponentShape {
  final double radius;
  final double borderWidth;

  const StrokeThumbShape({this.radius = 10, this.borderWidth = 2});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // fill (الدائرة الداخلية)
    final fillPaint = Paint()
      ..color = AppColors.primaryColor; // أو sliderTheme.thumbColor!
    canvas.drawCircle(center, radius, fillPaint);

    // border (الـ stroke)
    final borderPaint = Paint()
      ..color = Colors
          .white // نفس لون الـ active track مثلاً
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(center, radius, borderPaint);
  }
}

class SkillCard extends StatefulWidget {
  final String title;
  final double value;

  const SkillCard({super.key, required this.title, required this.value});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  late double _value;
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  String get status {
    if (_value < 40) return 'Weak';
    if (_value < 70) return 'Average';
    return 'Good';
  }

  Color get statusColor {
    if (_value < 40) return AppColors.weak;
    if (_value < 70) return AppColors.average;
    return AppColors.good;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 220, // Set a fixed width for the slider
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 8,
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: Colors.white,
                  overlappingShapeStrokeColor: AppColors.primaryColor,
    
                  thumbShape: const StrokeThumbShape(
                    radius: 6,
                    borderWidth: 5,
                  ),
                ),
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
    
                  child: Slider(
                    padding: EdgeInsets.zero,
                    value: _value,
                    min: 0,
                    max: 100,
                    onChanged: (val) {
                      setState(() => _value = val);
                      _debounceTimer != null
                          ? _debounceTimer?.cancel()
                          : _debounceTimer = Timer(
                              const Duration(milliseconds: 300),
                              () {
                                getIt<InputCubit>().doIntent(
                                  UpdateSkillProficiency(
                                    skill: SkillEntity(
                                      name: widget.title,
                                      proficiency: val.toInt(),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_value.round()}%',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.circle, size: 12, color: statusColor),
            const SizedBox(width: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
