import 'dart:async';

import 'package:career_lens/core/config/di/dependency_injection.dart';
import 'package:career_lens/features/input/presentation/cubit/input_cubit.dart';
import 'package:career_lens/features/input/presentation/cubit/input_event.dart';
import 'package:flutter/material.dart';

const _surface  = Color(0xFF131620);
const _border   = Color(0xFF1E2235);
const _accent   = Color(0xFF6C63FF);
const _textPrim = Color(0xFFEEF0FF);
const _textMuted= Color(0xFF6B7280);
const _weak     = Color(0xFFEF4444);
const _avg      = Color(0xFFF59E0B);
const _good     = Color(0xFF22D3A5);

class SkillCard extends StatefulWidget {
  final String title;
  final double value;

  const SkillCard({super.key, required this.title, required this.value});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  late double _value;
  Timer? _debounceTimer;
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryAnim;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _entryAnim =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _entryCtrl.dispose();
    super.dispose();
  }

  String get _label {
    if (_value < 40) return 'Weak';
    if (_value < 70) return 'Average';
    return 'Good';
  }

  Color get _labelColor {
    if (_value < 40) return _weak;
    if (_value < 70) return _avg;
    return _good;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _entryAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: _textPrim,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    // Pct label
                    Text(
                      '${_value.round()}%',
                      style: const TextStyle(
                        color: _textMuted,
                        fontSize: 12,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _labelColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(100),
                        border:
                            Border.all(color: _labelColor.withOpacity(0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _labelColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _labelColor.withOpacity(0.5),
                                  blurRadius: 4,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _label,
                            style: TextStyle(
                              color: _labelColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Custom slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                activeTrackColor: _accent,
                inactiveTrackColor: _border,
                thumbColor: Colors.white,
                thumbShape: _GlowThumbShape(),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 14),
                overlayColor: _accent.withOpacity(0.15),
              ),
              child: SizedBox(
                height: 24,
                child: Slider(
                  padding: EdgeInsets.zero,
                  value: _value,
                  min: 0,
                  max: 100,
                  onChanged: (val) {
                    setState(() => _value = val);
                    _debounceTimer?.cancel();
                    _debounceTimer =
                        Timer(const Duration(milliseconds: 300), () {
                      getIt<InputCubit>().doIntent(
                        UpdateSkillProficiency(
                          skillName: widget.title,
                          proficiency: val.round(),
                        ),
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom thumb with glow ─────────────────────────────────────────────────
class _GlowThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(9);

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

    // Glow
    canvas.drawCircle(
      center,
      13,
      Paint()
        ..color = _accent.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // White fill
    canvas.drawCircle(center, 9, Paint()..color = Colors.white);
    // Accent border
    canvas.drawCircle(
      center,
      9,
      Paint()
        ..color = _accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }
}
