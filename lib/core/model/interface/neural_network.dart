// lib/inference/neural_network.dart
//
// Stage 2: Neural Network — INFERENCE ONLY
// Pure Dart port. No external packages.
//
// Architecture:
//   Input (138)  →  ReLU Hidden1 (128)  →  ReLU Hidden2 (64)  →  Softmax Output (14)
//
// Weights are loaded from assets/model_weights.json.

import 'dart:math' as math;

/// Holds the loaded weight matrices.
class ModelWeights {
  final List<List<double>> w1; // (138, 128)
  final List<double> b1; // (128,)
  final List<List<double>> w2; // (128, 64)
  final List<double> b2; // (64,)
  final List<List<double>> w3; // (64, 14)
  final List<double> b3; // (14,)

  const ModelWeights({
    required this.w1,
    required this.b1,
    required this.w2,
    required this.b2,
    required this.w3,
    required this.b3,
  });

  /// Construct from the decoded JSON map.
  factory ModelWeights.fromJson(Map<String, dynamic> json) {
    List<List<double>> matrix(String key) => (json[key] as List)
        .map((row) => (row as List).map((v) => (v as num).toDouble()).toList())
        .toList();

    List<double> bias(String key) {
      // b1/b2/b3 are stored as [[...]] — shape (1, n)
      final raw = json[key] as List;
      if (raw.first is List) {
        return (raw.first as List).map((v) => (v as num).toDouble()).toList();
      }
      return raw.map((v) => (v as num).toDouble()).toList();
    }

    return ModelWeights(
      w1: matrix('W1'),
      b1: bias('b1'),
      w2: matrix('W2'),
      b2: bias('b2'),
      w3: matrix('W3'),
      b3: bias('b3'),
    );
  }
}

/// Inference-only neural network.
class NeuralNetwork {
  ModelWeights? _weights;

  bool get isLoaded => _weights != null;

  /// Must be called with a loaded ModelWeights before predict().
  void loadWeights(ModelWeights weights) {
    _weights = weights;
  }

  // ── Math primitives ────────────────────────────────────────────────────

  /// Matrix–vector multiply: result[i] = sum_j( mat[i][j] * vec[j] ) + bias[i]
  ///
  /// mat : (rows × cols)
  /// vec : (cols,)  — input
  /// out : (rows,)  — output
  static List<double> _matVecAdd(
    List<List<double>> mat,
    List<double> vec,
    List<double> bias,
  ) {
    final rows = mat.length;
    final cols = vec.length;
    final out = List<double>.filled(rows, 0.0);
    for (int i = 0; i < rows; i++) {
      double sum = bias[i];
      final row = mat[i];
      for (int j = 0; j < cols; j++) {
        sum += row[j] * vec[j];
      }
      out[i] = sum;
    }
    return out;
  }

  // ── Activations ────────────────────────────────────────────────────────

  static List<double> _relu(List<double> z) =>
      z.map((v) => v > 0 ? v : 0.0).toList();

  static List<double> _softmax(List<double> z) {
    final maxVal = z.reduce(math.max);
    final exp = z.map((v) => math.exp(v - maxVal)).toList();
    final sum = exp.reduce((a, b) => a + b);
    return exp.map((v) => v / sum).toList();
  }

  // ── Forward pass ───────────────────────────────────────────────────────

  /// [input] must be a 138-element list with values in [0, 1].
  /// Returns a 14-element probability list (sums to 1.0).
  List<double> predict(List<double> input) {
    assert(_weights != null, 'Call loadWeights() before predict()');
    final w = _weights!;

    // ✅ احذف السطر ده تماماً — مش محتاجه وبيعمل crash
    // final z1 = _matVecAdd(w.w1.map((row) => row).toList(), input, w.b1);

    final a1 = _relu(_dense(w.w1, w.b1, input));
    final a2 = _relu(_dense(w.w2, w.b2, a1));
    final a3 = _softmax(_dense(w.w3, w.b3, a2));

    return a3;
  }

  /// Dense layer: out[j] = sum_i( mat[i][j] * in[i] ) + bias[j]
  /// mat is stored as (n_in × n_out) — same as NumPy @ operator.
  static List<double> _dense(
    List<List<double>> mat,
    List<double> bias,
    List<double> input,
  ) {
    final nIn = mat.length;
    final nOut = bias.length;
    final out = List<double>.filled(nOut, 0.0);

    for (int i = 0; i < nIn; i++) {
      final xi = input[i];
      final row = mat[i];
      for (int j = 0; j < nOut; j++) {
        out[j] += row[j] * xi;
      }
    }
    for (int j = 0; j < nOut; j++) {
      out[j] += bias[j];
    }
    return out;
  }
}
