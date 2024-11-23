import 'package:feel_sync/EmotionDetector/EmotionPredictor.dart';
import 'package:feel_sync/EmotionDetector/ResourceManager.dart';
import 'package:feel_sync/EmotionDetector/TextPreProcessing.dart';
import 'package:feel_sync/EmotionDetector/Vectorizer.dart';

class EmotionDetectionManager {
  final ResourceManager _resourceManager = ResourceManager();
  late TextPreprocessor _textPreprocessor;
  late TFIDFVectorizer _tfidfVectorizer;
  final EmotionPredictor _emotionPredictor = EmotionPredictor();

  Future<void> initialize() async {
    await _resourceManager.loadResources();
    _textPreprocessor = TextPreprocessor(_resourceManager.stopWords);
    _tfidfVectorizer = TFIDFVectorizer(
      _resourceManager.vocabulary,
      _resourceManager.idfValues,
    );
    await _emotionPredictor.loadModel();
  }

  Future<String> detectEmotion(String text) async {
    // Preprocess the text
    String preprocessedText = _textPreprocessor.preprocess(text);

    List<double> tfidfVector = _tfidfVectorizer.computeTFIDF(preprocessedText);
    // Predict emotion
    return _emotionPredictor.predict(tfidfVector);
  }
}
