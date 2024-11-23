class TFIDFVectorizer {
  final Map<String, int> vocabulary;
  final List<double> idfValues;

  // Constructor to initialize vocabulary and IDF values
  TFIDFVectorizer(this.vocabulary, this.idfValues);

  /// Method to compute the TF-IDF vector for a given text
  List<double> computeTFIDF(String text) {
    // Tokenize the input text and convert to lowercase
    List<String> tokens = _tokenize(text);

    // Compute Term Frequency (TF)
    Map<String, int> termFrequency = {};
    for (var token in tokens) {
      if (vocabulary.containsKey(token)) {
        termFrequency[token] = (termFrequency[token] ?? 0) + 1;
      }
    }

    // If no valid terms are found, return a zeroed vector
    if (termFrequency.isEmpty) return List.filled(vocabulary.length, 0.0);

    // Find max frequency for normalization
    int maxFreq = termFrequency.values.reduce((a, b) => a > b ? a : b);

    // Normalize term frequency (TF)
    Map<String, double> normalizedTF = {};
    termFrequency.forEach((term, freq) {
      normalizedTF[term] = freq / maxFreq;
    });

    // Prepare a vector to store the TF-IDF values for each word in the vocabulary
    List<double> tfidfVector = List.filled(vocabulary.length, 0.0);

    // Calculate TF-IDF for each term present in the vocabulary
    normalizedTF.forEach((term, normalizedFreq) {
      int index = vocabulary[term]!;
      double tfidfValue = normalizedFreq * idfValues[index];
      tfidfVector[index] = tfidfValue;
    });
    return tfidfVector;
  }

  /// Method to tokenize the input text using regex and convert to lowercase
  List<String> _tokenize(String text) {
    // Updated regex pattern to match words with 2 or more characters
    RegExp tokenPattern = RegExp(r"\b\w{2,}\b");
    return tokenPattern
        .allMatches(text.toLowerCase())
        .map((match) => match.group(0)!)
        .toList();
  }
}
