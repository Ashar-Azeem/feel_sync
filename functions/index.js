const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");

initializeApp();

exports.calculateCompatibility = onDocumentUpdated("chats/{chatId}",
  (event) => {
    const beforeData = event.data.before.data();
    const afterData = event.data.after.data();

    const fieldsOfInterest = ["user1Emotions", "user2Emotions"];
    const hasChanged = fieldsOfInterest.some((field) =>
      JSON.stringify(beforeData[field]) !==
      JSON.stringify(afterData[field]),
    );

    if (!hasChanged) {
      return null;
    }
    const newData = event.data.after.data();
    const user1Emotions = newData.user1Emotions;
    const user2Emotions = newData.user2Emotions;
    const oldCompatibility = newData.compatibility;

    const sumArray = (arr) =>
      arr.reduce((sum, val) => sum + val, 0);

    const normalize = (arr) => {
      const total = sumArray(arr);
      return total === 0 ?
        arr.map(() => 0) : arr.map((val) => val / total);
    };

    const cosineSimilarity = (arr1, arr2) => {
      const dotProduct = arr1.reduce((sum, val, i) => sum + val * arr2[i], 0);
      const magnitude1 =
        Math.sqrt(arr1.reduce((sum, val) => sum + val * val, 0));
      const magnitude2 =
        Math.sqrt(arr2.reduce((sum, val) => sum + val * val, 0));
      return magnitude1 === 0 || magnitude2 === 0 ? 0 :
        dotProduct / (magnitude1 * magnitude2);
    };

    const complementarityScore = (user1, user2, sumUser1, sumUser2) => {
      const [anger1, fear1, joy1, love1, sadness1] = user1;
      const [anger2, fear2, joy2, love2, sadness2] = user2;

      let score = 0;
      if (sadness1 > 0) {
        score += (joy2 + love2) / sadness1;
      }
      if (sadness2 > 0) {
        score += (joy1 + love1) / sadness2;
      }
      if (anger1 > 0) {
        score += love2 / anger1;
      }
      if (anger2 > 0) {
        score += love1 / anger2;
      }
      if (fear1 > 0) {
        score += love2 / fear1;
      }
      if (fear2 > 0) {
        score += love1 / fear2;
      }
      score += 0.5 * (joy1 * joy2 + love1 * love2);
      return sumUser1 === 0 || sumUser2 === 0 ? 0 :
        score / (sumUser1 + sumUser2);
    };

    const user1Array = Object.values(user1Emotions);
    const user2Array = Object.values(user2Emotions);

    const sumUser1 = sumArray(user1Array);
    const sumUser2 = sumArray(user2Array);

    if (sumUser1 === 0 || sumUser2 === 0) {
      return event.data.after.ref.update({
        compatibility: 0.0,
      });
    }

    const normalizedUser1 = normalize(user1Array);
    const normalizedUser2 = normalize(user2Array);

    const cosineScore =
      cosineSimilarity(normalizedUser1, normalizedUser2);
    const complementarity =
      complementarityScore(user1Array, user2Array, sumUser1, sumUser2);

    const interactionBalance =
      Math.min(sumUser1, sumUser2) / Math.max(sumUser1, sumUser2);

    const compatibilityScore =
      ((complementarity * 0.5) + (cosineScore * 0.5)) * interactionBalance;

    const finalScore = Math.min(100, Math.max(0, compatibilityScore * 100));
    const updatedScore = oldCompatibility * 0.6 + finalScore * 0.4;

    return event.data.after.ref.update({
      compatibility: Number(updatedScore.toFixed(2)),
    });
  });
