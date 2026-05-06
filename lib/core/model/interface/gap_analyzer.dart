// lib/inference/gap_analyzer.dart
//
// Stage 3: Gap Analyzer
// Rule-based post-processing. No ML, no dependencies.

/// A single missing skill entry.
class MissingSkill {
  final String id;
  final String name;
  final String category;
  final double required;
  final double current;
  final double gap;
  final String priority; // 'High', 'Medium', or 'Low'

  const MissingSkill({
    required this.id,
    required this.name,
    required this.category,
    required this.required,
    required this.current,
    required this.gap,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
    'id':       id,
    'name':     name,
    'category': category,
    'required': required,
    'current':  current,
    'gap':      gap,
    'priority': priority,
  };
}

/// Full gap report for one track.
class GapReport {
  final String trackId;
  final String trackName;
  final double progress;      // weighted completion %
  final int totalSkills;
  final int missingCount;
  final List<MissingSkill> missingSkills;

  const GapReport({
    required this.trackId,
    required this.trackName,
    required this.progress,
    required this.totalSkills,
    required this.missingCount,
    required this.missingSkills,
  });

  Map<String, dynamic> toJson() => {
    'track_id':       trackId,
    'track_name':     trackName,
    'progress':       progress,
    'total_skills':   totalSkills,
    'missing_count':  missingCount,
    'missing_skills': missingSkills.map((s) => s.toJson()).toList(),
  };
}

class GapAnalyzer {
  static const double _threshold = 0.6;
  static const int    _maxMissing = 15;

  /// [userSkills]  — fuzzified scores {skill_id: 0-100}
  /// [trackId]     — e.g. 'fullstack_django'
  /// [tracks]      — full tracks map from data.json
  /// [skills]      — full skills map from data.json
  static GapReport analyze({
    required Map<String, double> userSkills,
    required String trackId,
    required Map<String, dynamic> tracks,
    required Map<String, dynamic> skills,
  }) {
    final track    = tracks[trackId] as Map<String, dynamic>;
    final required = (track['required_skills'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, (v as num).toDouble()));

    double satisfiedWeight = 0.0;
    double totalWeight     = 0.0;
    final missing          = <MissingSkill>[];

    required.forEach((sid, reqScore) {
      final weight    = reqScore / 100.0;
      final userScore = userSkills[sid] ?? 0.0;
      final ratio     = reqScore > 0 ? userScore / reqScore : 1.0;

      totalWeight += weight;

      if (ratio >= _threshold) {
        satisfiedWeight += weight;
      } else {
        final gap      = reqScore - userScore;
        final skillMap = skills[sid] as Map<String, dynamic>?;
        missing.add(MissingSkill(
          id:       sid,
          name:     skillMap?['name'] as String? ?? sid,
          category: skillMap?['category'] as String? ?? '',
          required: double.parse(reqScore.toStringAsFixed(1)),
          current:  double.parse(userScore.toStringAsFixed(1)),
          gap:      double.parse(gap.toStringAsFixed(1)),
          priority: gap > 40 ? 'High' : (gap > 20 ? 'Medium' : 'Low'),
        ));
      }
    });

    missing.sort((a, b) => b.gap.compareTo(a.gap));

    final progress = totalWeight > 0
        ? double.parse((satisfiedWeight / totalWeight * 100).toStringAsFixed(1))
        : 0.0;

    return GapReport(
      trackId:       trackId,
      trackName:     track['name'] as String,
      progress:      progress,
      totalSkills:   required.length,
      missingCount:  missing.length,
      missingSkills: missing.take(_maxMissing).toList(),
    );
  }
}
