import 'package:stemmer/stemmer.dart';

class TextPreprocessor {
  final List<String> stopWords;

  TextPreprocessor(this.stopWords);

  /// Preprocess the input text (lowercase, remove stop words, stemming)
  String preprocess(String text) {
    // Convert text to lowercase
    text = text.toLowerCase();

    // Remove non-alphabetic characters
    text = text.replaceAll(RegExp(r'[^a-zA-Z\s]'), ' ');

    // Tokenize and remove stop words
    List<String> tokens = text.split(' ').where((word) {
      return word.isNotEmpty && !stopWords.contains(word);
    }).toList();

    // Apply stemming
    PorterStemmer stemmer = PorterStemmer();
    List<String> stemmedTokens =
        tokens.map((word) => stemmer.stem(word)).toList();

    return stemmedTokens.join(' ');
  }
}
