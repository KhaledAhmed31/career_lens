// lib/services/career_predictor_service.dart
//
// Flutter integration layer.
// Loads model weights + skill/track catalog from assets at startup,
// then runs the full Fuzzy → NN → Gap pipeline locally (no network call).
//
// ── pubspec.yaml asset entries required ───────────────────────────────────
//   flutter:
//     assets:
//       - assets/model_weights.json
//       - assets/data.json
// ─────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:career_lens/core/model/interface/fuzzy_inference.dart';
import 'package:career_lens/core/model/interface/gap_analyzer.dart';
import 'package:career_lens/core/model/interface/neural_network.dart';
import 'package:career_lens/core/utils/const/app_json.dart';
import 'package:flutter/services.dart' show rootBundle;

// ── Data models ────────────────────────────────────────────────────────────

class TrackResult {
  final int rank;
  final String trackId;
  final String name;
  final String icon;
  final String color;
  final String description;
  final double confidence;

  const TrackResult({
    required this.rank,
    required this.trackId,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'track_id': trackId,
    'name': name,
    'icon': icon,
    'color': color,
    'description': description,
    'confidence': confidence,
  };
}

class SkillLabel {
  final double fuzzified;
  final double raw;
  final String level;

  const SkillLabel({
    required this.fuzzified,
    required this.raw,
    required this.level,
  });

  Map<String, dynamic> toJson() => {
    'fuzzified': fuzzified,
    'raw': raw,
    'level': level,
  };
}

/// Full prediction result — matches the Python output contract exactly.
class PredictionResult {
  final List<TrackResult> topTracks;
  final GapReport gapAnalysis;
  final Map<String, SkillLabel> skillLabels;
  final int totalTracks;

  const PredictionResult({
    required this.topTracks,
    required this.gapAnalysis,
    required this.skillLabels,
    required this.totalTracks,
  });

  Map<String, dynamic> toJson() => {
    'top_tracks': topTracks.map((t) => t.toJson()).toList(),
    'gap_analysis': gapAnalysis.toJson(),
    'skill_labels': skillLabels.map((k, v) => MapEntry(k, v.toJson())),
    'total_tracks': totalTracks,
  };
}

// ── Service ────────────────────────────────────────────────────────────────

/// Singleton service. Call [initialize] once (e.g. in main() or initState).
///
/// ```dart
/// await CareerPredictorService.instance.initialize();
/// final result = CareerPredictorService.instance.predict({'python': 80, 'django': 70});
/// ```
class CareerPredictorService {
  CareerPredictorService._();
  static final instance = CareerPredictorService._();

  final _nn = NeuralNetwork();

  late List<String> _skillIds; // 138 entries — fixed order
  late List<String> _trackIds; // 14 entries  — fixed order
  late Map<String, dynamic> _skills;
  late Map<String, dynamic> _tracks;

  bool _ready = false;
  bool get isReady => _ready;

  /// Call once before calling [predict].
  /// Safe to await in main() or a FutureBuilder.
  Future<void> initialize() async {
    if (_ready) return;

    // Load and parse assets in parallel
    final results = await Future.wait([
      rootBundle.loadString(AppJson.modelWeights),
      rootBundle.loadString(AppJson.data),
    ]);

    final weightsJson = jsonDecode(results[0]) as Map<String, dynamic>;
    final dataJson = jsonDecode(results[1]) as Map<String, dynamic>;

    _nn.loadWeights(ModelWeights.fromJson(weightsJson));

    _skills = dataJson['skills'] as Map<String, dynamic>;
    _tracks = dataJson['tracks'] as Map<String, dynamic>;
    _skillIds = _skills.keys.toList();
    _trackIds = _tracks.keys.toList();

    _ready = true;
  }

  // ── Core prediction ───────────────────────────────────────────────────

  /// [rawSkills] — { skill_id: score 0-100 }
  ///
  /// INPUT  : { "python": 80, "django": 70 }
  /// OUTPUT :
  ///   PredictionResult {
  ///     topTracks   : top-3 tracks with confidence %
  ///     gapAnalysis : missing skills for #1 track
  ///     skillLabels : per-skill fuzzified value + level label
  ///     totalTracks : 14
  ///   }
  PredictionResult predict(Map<String, double> rawSkills) {
    assert(_ready, 'Call initialize() and await it before predict()');

    // 1. Fuzzy correction
    final fuzzified = FuzzyInference.processSkills(rawSkills);

    // 2. Build 138-dim input vector (values 0-1)
    final skillIdx = {
      for (int i = 0; i < _skillIds.length; i++) _skillIds[i]: i,
    };
    final vec = List<double>.filled(_skillIds.length, 0.0);
    fuzzified.forEach((sid, val) {
      final idx = skillIdx[sid];
      if (idx != null) vec[idx] = val / 100.0;
    });

    // 3. Neural network inference → 14 probabilities
    final proba = _nn.predict(vec);

    // 4. Top-3 tracks
    final ranked = List<int>.generate(proba.length, (i) => i)
      ..sort((a, b) => proba[b].compareTo(proba[a]));
    final top3 = ranked.take(3).toList();

    final topTracks = top3.asMap().entries.map((e) {
      final rank = e.key + 1;
      final idx = e.value;
      final tid = _trackIds[idx];
      final info = _tracks[tid] as Map<String, dynamic>;
      return TrackResult(
        rank: rank,
        trackId: tid,
        name: info['name'] as String,
        icon: info['icon'] as String,
        color: info['color'] as String,
        description: info['description'] as String,
        confidence: double.parse((proba[idx] * 100).toStringAsFixed(1)),
      );
    }).toList();

    // 5. Gap analysis on #1 track
    final bestId = _trackIds[top3[0]];
    final gapData = GapAnalyzer.analyze(
      userSkills: fuzzified,
      trackId: bestId,
      tracks: _tracks,
      skills: _skills,
    );

    // 6. Skill labels
    final skillLabels = <String, SkillLabel>{};
    fuzzified.forEach((sid, val) {
      skillLabels[sid] = SkillLabel(
        fuzzified: double.parse(val.toStringAsFixed(1)),
        raw: double.parse((rawSkills[sid] ?? 0.0).toStringAsFixed(1)),
        level: FuzzyInference.getLinguisticLabel(rawSkills[sid] ?? 0.0),
      );
    });

    return PredictionResult(
      topTracks: topTracks,
      gapAnalysis: gapData,
      skillLabels: skillLabels,
      totalTracks: _trackIds.length,
    );
  }
}
