// lib/inference/fuzzy_inference.dart
//
// Stage 1: Fuzzy Inference System
// Exact Dart port of the Python FuzzyInference class.
// No dependencies beyond dart:core.

/// Maps a raw 0-100 skill score to a bias-corrected score using
/// triangular membership functions and centre-of-gravity defuzzification.
class FuzzyInference {
  // Centroids for CoG defuzzification
  static const double _cBeginner = 0.0;
  static const double _cIntermediate = 50.0;
  static const double _cExpert = 100.0;

  // ── Membership functions ────────────────────────────────────────────────

  static double _muBeginner(double x) {
    if (x <= 0) return 1.0;
    if (x >= 40) return 0.0;
    return 1.0 - (x / 40.0);
  }

  static double _muIntermediate(double x) {
    if (x <= 10 || x >= 90) return 0.0;
    if (x <= 50) return (x - 10) / 40.0;
    return (90.0 - x) / 40.0;
  }

  static double _muExpert(double x) {
    if (x <= 60) return 0.0;
    if (x >= 100) return 1.0;
    return (x - 60.0) / 40.0;
  }

  // ── Public API ──────────────────────────────────────────────────────────

  /// Returns membership degrees for all three linguistic variables.
  static Map<String, double> fuzzify(double score) {
    final x = score.clamp(0.0, 100.0);
    return {
      'beginner': _muBeginner(x),
      'intermediate': _muIntermediate(x),
      'expert': _muExpert(x),
    };
  }

  /// Centre-of-gravity defuzzification + self-assessment bias correction.
  /// Returns corrected score in [0, 100].
  static double defuzzify(double score) {
    final x = score.clamp(0.0, 100.0);
    final mu = fuzzify(x);

    final num = mu['beginner']!     * _cBeginner
              + mu['intermediate']! * _cIntermediate
              + mu['expert']!       * _cExpert;
    final den = mu['beginner']! + mu['intermediate']! + mu['expert']!;

    double crisp = (den > 0) ? (num / den) : x;

    // Bias correction
    if (x < 40) {
      crisp *= 1.05;   // imposter syndrome boost
    } else if (x > 70) {
      crisp *= 0.93;   // over-confidence penalty
    }

    return crisp.clamp(0.0, 100.0);
  }

  /// Apply defuzzify() to every skill in the map.
  static Map<String, double> processSkills(Map<String, double> rawSkills) {
    return rawSkills.map((sid, val) => MapEntry(sid, defuzzify(val)));
  }

  /// Returns 'Beginner', 'Intermediate', or 'Expert'.
  static String getLinguisticLabel(double score) {
    final mu = fuzzify(score);
    final best = mu.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    // Capitalise first letter
    final key = best.key;
    return key[0].toUpperCase() + key.substring(1);
  }
}
