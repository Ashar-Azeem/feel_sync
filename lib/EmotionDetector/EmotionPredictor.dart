import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math';

class EmotionPredictor {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter =
        await Interpreter.fromAsset('assets/emotion_detection.tflite');
  }

  String predict(List<double> tfidfVector) {
    var input = [tfidfVector];
    var output = List.filled(5, 0.0).reshape([1, 5]);

    _interpreter.run(input, output);

    List<String> labels = ["Sadness", "Joy", "Love", "Anger", "Fear"];
    List<double> prob = List.from(output[0]);
    double maxValue = prob.reduce(max);
    int predictedIndex = output[0].indexWhere((value) => value == maxValue);

    return labels[predictedIndex];
  }
}
