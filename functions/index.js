const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");

initializeApp();

exports.calculateCompatibility =
  onDocumentUpdated("chats/{chatId}", (event) => {
    const newData = event.data.after.data();
    const user1Emotions = newData.user1Emotions;
    const user2Emotions = newData.user2Emotions;

    const user1Array = Object.values(user1Emotions);
    const user2Array = Object.values(user2Emotions);

    const sumArray = (arr) => arr.reduce((sum, val) => sum + val, 0);

    // Check if the sum of any emotion map is zero
    const sumUser1 = sumArray(user1Array);
    const sumUser2 = sumArray(user2Array);
    if (sumUser1 === 0 || sumUser2 === 0) {
      return event.data.after.ref.update({
        compatibility: "0.00",
      });
    }

    // Balance interaction check
    const interactionBalance =
      Math.min(sumUser1, sumUser2) / Math.max(sumUser1, sumUser2);

    // Penalize one-sided dominance
    const oneSidedPenalty = 1 - interactionBalance;

    const normalize = (arr) => {
      const total = sumArray(arr);
      return arr.map((val) => val / total);
    };

    const cosineSimilarity = (arr1, arr2) => {
      const dotProduct =
        arr1.reduce((sum, val, i) =>
          sum + val * arr2[i], 0);
      const magnitude1 =
        Math.sqrt(arr1.reduce((sum, val) =>
          sum + val * val, 0));
      const magnitude2 =
        Math.sqrt(arr2.reduce((sum, val) =>
          sum + val * val, 0));
      return dotProduct / (magnitude1 * magnitude2);
    };

    const manhattanDistance = (arr1, arr2) => {
      const distance = arr1.reduce((sum, val, i) =>
        sum + Math.abs(val - arr2[i]), 0);
      return 1 - distance / arr1.length;
    };

    const complementarityScore = (user1, user2) => {
      const [anger1, fear1, joy1, love1, sadness1] = user1;
      const [anger2, fear2, joy2, love2, sadness2] = user2;

      let score = 0;

      // Complementarity logic
      if (sadness1 > 0 && (joy2 > 0 || love2 > 0)) {
        score +=
          sadness1 * (joy2 + love2);
      }
      if (sadness2 > 0 && (joy1 > 0 || love1 > 0)) {
        score +=
          sadness2 * (joy1 + love1);
      }
      if (fear1 > 0 && (joy2 > 0 || love2 > 0)) {
        score +=
          fear1 * (joy2 + love2);
      }
      if (fear2 > 0 && (joy1 > 0 || love1 > 0)) {
        score +=
          fear2 * (joy1 + love1);
      }

      // Penalize shared negative emotions
      score -= (anger1 * anger2 + sadness1 * sadness2);

      // Reward high love or joy correlations
      score += 0.5 * (love1 * love2 + joy1 * joy2);

      return score / (sumUser1 + sumUser2);
    };

    const emotionDiversityScore = (arr) => {
      // Higher diversity in emotions is rewarded
      const uniqueEmotions = arr.filter((val) => val > 0).length;
      return uniqueEmotions / arr.length;
    };

    const normalizedUser1 = normalize(user1Array);
    const normalizedUser2 = normalize(user2Array);

    const cosineScore =
      cosineSimilarity(normalizedUser1, normalizedUser2);
    const manhattanScore =
      manhattanDistance(normalizedUser1, normalizedUser2);
    const complementarity = complementarityScore(user1Array, user2Array);

    // Emotion diversity contribution
    const diversityScore = (emotionDiversityScore(user1Array) +
      emotionDiversityScore(user2Array)) / 2;

    const compatibilityScore =
      ((cosineScore * 0.3) + (manhattanScore * 0.25) +
        (complementarity * 0.3) + (diversityScore * 0.15)) *
      interactionBalance * (1 - oneSidedPenalty);

    const finalScore =
      Math.min(100, Math.max(0, compatibilityScore * 100));

    return event.data.after.ref.update({
      compatibility: finalScore.toFixed(2),
    });
  });
