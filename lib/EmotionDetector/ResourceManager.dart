import 'dart:convert';
import 'package:flutter/services.dart';

class ResourceManager {
  late Map<String, int> vocabulary;
  late List<double> idfValues;
  late List<String> stopWords;

  /// Load resources like vocabulary, IDF values, and stop words from assets
  Future<void> loadResources() async {
    // Load vocabulary and IDF values
    String vocabData = await rootBundle.loadString('assets/tfidf_vocab.json');
    Map<String, dynamic> tfidfData = jsonDecode(vocabData);
    vocabulary = Map<String, int>.from(tfidfData['vocabulary']);
    idfValues = List<double>.from(tfidfData['idf']);

    // Load stop words
    String stopWordsData =
        await rootBundle.loadString('assets/stop_words.json');
    stopWords = List<String>.from(jsonDecode(stopWordsData));
  }
}
