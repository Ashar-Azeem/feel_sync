import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Models/user.dart';

class Crud {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');

  Future<void> insertUser(String userId, String name, String userName,
      String? profileLocation, String token, int age, String gender) async {
    try {
      await userCollection.doc(userId).set({
        'name': name,
        'userName': userName,
        'bio': '',
        'profileLocation': profileLocation,
        'token': token,
        'gender': gender,
        'age': age,
        'compatibility': 0
      });
    } catch (e) {
      //
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      DocumentSnapshot result = await userCollection.doc(userId).get();
      if (result.exists) {
        User user = User.fromDocumentSnapshot(result);

        return user;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> userNameExists(String userName) async {
    QuerySnapshot querySnapshot = await userCollection
        .where("userName", isEqualTo: userName)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeProfilePictureInDataBase(
      {required String userId, required String profileLocation}) async {
    try {
      DocumentReference result = userCollection.doc(userId);
      await result.update({"profileLocation": profileLocation});
      QuerySnapshot docs = await chatCollection
          .where(Filter.or(Filter('user1UserId', isEqualTo: userId),
              Filter('user2UserId', isEqualTo: userId)))
          .get();
      for (QueryDocumentSnapshot documentSnapshot in docs.docs) {
        DocumentReference documentRef = chatCollection.doc(documentSnapshot.id);
        var chat = Chat.fromDocumentSnapshot(documentSnapshot);
        if (chat.user1UserId == userId) {
          await documentRef.update({'user1ProfileLoc': profileLocation});
        } else {
          await documentRef.update({'user2ProfileLoc': profileLocation});
        }
      }

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> changeName(
      {required String userId, required String newName}) async {
    try {
      DocumentReference result = userCollection.doc(userId);
      await result.update({"name": newName});

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> changeUserName(
      {required String userId, required String newUserName}) async {
    try {
      bool userNameCheck = await userNameExists(newUserName);
      if (!userNameCheck) {
        DocumentReference result = userCollection.doc(userId);
        await result.update({"userName": newUserName});
        return true;
      } else {
        throw Exception("User Already Exists");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> changeAboutSection(
      {required String userId, required String newAbout}) async {
    try {
      DocumentReference result = userCollection.doc(userId);
      await result.update({"bio": newAbout});

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<User>> retreiveUsers(String userName) async {
    try {
      List<User> users = [];
      QuerySnapshot data = await userCollection
          .where('userName', isGreaterThanOrEqualTo: userName)
          .where('userName', isLessThan: '${userName}z')
          .get();

      for (QueryDocumentSnapshot documentSnapshot in data.docs) {
        User user = User.fromDocumentSnapshot(documentSnapshot);
        users.add(user);
      }
      return users;
    } catch (e) {
      //
    }
    return [];
  }

  Future<Chat> createChat({required Chat demoChat}) async {
    try {
      // Reference to the Firestore collection
      final chatCollection = FirebaseFirestore.instance.collection('chats');

      // Prepare the data to be added
      final chatData = {
        'user1UserId': demoChat.user1UserId,
        'user1UserName': demoChat.user1UserName,
        'user1FCMToken': demoChat.user1FCMToken,
        'user1ProfileLoc': demoChat.user1ProfileLoc,
        'user2UserId': demoChat.user2UserId,
        'user2UserName': demoChat.user2UserName,
        'user2FCMToken': demoChat.user2FCMToken,
        'user2ProfileLoc': demoChat.user2ProfileLoc,
        'user1Seen': true,
        'user2Seen': false,
        'compatibility': 0.0,
        'user1Emotions': {
          'Sadness': 0,
          'Joy': 0,
          'Love': 0,
          'Anger': 0,
          'Fear': 0
        },
        'user2Emotions': {
          'Sadness': 0,
          'Joy': 0,
          'Love': 0,
          'Anger': 0,
          'Fear': 0
        },
        'lastMessage': '',
        'lastMessageDateTime': DateTime.now()
      };

      // Add the data to Firestore and get the document reference
      DocumentReference docRef = await chatCollection.add(chatData);

      // Return a Chat object without fetching it
      Chat chat = Chat(
          chatId: docRef.id, // Use the document ID directly
          user1UserId: demoChat.user1UserId,
          user1UserName: demoChat.user1UserName,
          user1FCMToken: demoChat.user1FCMToken,
          user1ProfileLoc: demoChat.user1ProfileLoc,
          user2UserId: demoChat.user2UserId,
          user2UserName: demoChat.user2UserName,
          user2FCMToken: demoChat.user2FCMToken,
          user2ProfileLoc: demoChat.user2ProfileLoc,
          user1Seen: true,
          user2Seen: false,
          compatibility: 0.0,
          user1Emotions: const {
            'Sadness': 0,
            'Joy': 0,
            'Love': 0,
            'Anger': 0,
            'Fear': 0
          },
          user2Emotions: const {
            'Sadness': 0,
            'Joy': 0,
            'Love': 0,
            'Anger': 0,
            'Fear': 0
          },
          lastMessage: "",
          lastMessageDateTime: DateTime.now());
      return chat;
    } catch (e) {
      // Handle exceptions
      print('Error creating chat: $e');
      rethrow;
    }
  }

  Future<Chat?> getChat(User ownerUser, User otherUser) async {
    Chat? chat;
    try {
      var query1 = await chatCollection
          .where('user1UserId', isEqualTo: ownerUser.userId)
          .where('user2UserId', isEqualTo: otherUser.userId)
          .limit(1)
          .get();

      // Query 2: user2UserId matches senderId or receiverId
      var query2 = await chatCollection
          .where('user2UserId', isEqualTo: ownerUser.userId)
          .where('user1UserId', isEqualTo: otherUser.userId)
          .limit(1)
          .get();

      List<QueryDocumentSnapshot> docs = query1.docs + query2.docs;
      if (docs.isEmpty) {
        return chat;
      } else {
        chat = Chat.fromDocumentSnapshot(docs[0]);
        return chat;
      }
    } catch (e) {
      print(e);
//
      return null;
    }
  }

  Future<Chat> getChatById(Chat chat) async {
    DocumentSnapshot result = await chatCollection.doc(chat.chatId).get();
    if (result.exists) {
      Chat chatToBeReturned = Chat.fromDocumentSnapshot(result);
      return chatToBeReturned;
    } else {
      return chat;
    }
  }

  Future<Chat> insertMessage(
      String senderUserId,
      String receiverUserId,
      Chat demoChat,
      String content,
      DateTime time,
      String emotionKey,
      int receiverNumber) async {
    if (demoChat.chatId == null) {
      demoChat = await createChat(demoChat: demoChat);
    }

    await messageCollection.add({
      'chatId': demoChat.chatId,
      'senderUserId': senderUserId,
      'receiverUserId': receiverUserId,
      'content': content,
      'time':
          Timestamp.fromDate(time), // Convert DateTime to Firestore Timestamp
    });

    await updateChat(
        chatId: demoChat.chatId!,
        emotionKey: emotionKey,
        receiverNumber: receiverNumber,
        lastMessage: content);

    return demoChat;
  }

  Future<void> updateChat(
      {required String chatId,
      required String emotionKey,
      required int receiverNumber,
      required String lastMessage}) async {
    try {
      // Reference to the specific chat document
      final DocumentReference chatDoc =
          FirebaseFirestore.instance.collection('chats').doc(chatId);
      if (receiverNumber == 1) {
        await chatDoc.update({
          'user${2}Emotions.$emotionKey':
              FieldValue.increment(1), // Update the sender userEmotions map

          'user${receiverNumber}Seen': false,
          'lastMessage': lastMessage,
          'lastMessageDateTime': DateTime.now()
        });
      } else {
        await chatDoc.update({
          'user${1}Emotions.$emotionKey':
              FieldValue.increment(1), // Update the sender userEmotions map
          'user${receiverNumber}Seen': false,
          'lastMessage': lastMessage,
          'lastMessageDateTime': DateTime.now()
        });
      }
    } catch (e) {
//
    }
  }

  Future<void> messageSeenUpdate(
      {required String chatId, required receiverNumber}) async {
    final DocumentReference chatDoc =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    if (receiverNumber == 1) {
      await chatDoc.update({'user2Seen': true});
    } else {
      await chatDoc.update({'user1Seen': true});
    }
  }

  Future<double> measureCompatibility(String userId) async {
    double combatibilityMeasure = 0;
    QuerySnapshot docs = await chatCollection
        .where(Filter.or(Filter('user1UserId', isEqualTo: userId),
            Filter('user2UserId', isEqualTo: userId)))
        .get();
    if (docs.docs.isEmpty) {
      return combatibilityMeasure;
    }
    for (QueryDocumentSnapshot documentSnapshot in docs.docs) {
      var chat = Chat.fromDocumentSnapshot(documentSnapshot);
      combatibilityMeasure += chat.compatibility;
    }
    return (combatibilityMeasure / docs.docs.length).roundToDouble();
  }

//Fetch all the data of the main user
//Fetch the other user involved in the chat
//For ageGroup make groups : (16-22),(23-29),(30-36),(37-43),(44-50),(50+)
// Take mean of their compatibilty and put then into their corresponding key in the ageMap
//For genderGroup make groups : Male and Female
// Take mean of their compatibilty and put then into their corresponding key in the ageMap
  Future<AnalysisData> getAnalysisData(String userId) async {
    List<Chat> allChats = [];
    List<User> allUsers = [];
    Map<String, int> ageGroupAnalysis = {
      "16-22": 0,
      "23-29": 0,
      "30-36": 0,
      "37-43": 0,
      "44-50": 0,
      "50+": 0,
    };
    Map<String, int> genderGroupAnalysis = {
      "Male": 0,
      "Female": 0,
    };
    List<int> ageDivisor = [0, 0, 0, 0, 0, 0];
    List<int> genderDivisor = [0, 0];

    QuerySnapshot docs = await chatCollection
        .where(Filter.or(Filter('user1UserId', isEqualTo: userId),
            Filter('user2UserId', isEqualTo: userId)))
        .get();
    if (docs.docs.isEmpty) {
      return AnalysisData(
          ageGroupAnalysis: ageGroupAnalysis,
          genderGroupAnalysis: genderGroupAnalysis);
    }

    for (QueryDocumentSnapshot documentSnapshot in docs.docs) {
      allChats.add(Chat.fromDocumentSnapshot(documentSnapshot));
    }
    //Fetching all user associated in chat
    for (Chat chat in allChats) {
      if (chat.user1UserId == userId) {
        allUsers.add(User.fromDocumentSnapshot(
            await userCollection.doc(chat.user2UserId).get()));
      } else {
        allUsers.add(User.fromDocumentSnapshot(
            await userCollection.doc(chat.user1UserId).get()));
      }
    }

    for (User user in allUsers) {
      int compatibility = allChats
          .firstWhere((chat) =>
              (chat.user1UserId == user.userId) ||
              (chat.user2UserId == user.userId))
          .compatibility
          .toInt();
      if (user.age > 50) {
        ageGroupAnalysis["50+"] =
            (ageGroupAnalysis["50+"] ?? 0) + compatibility;

        ageDivisor[5] += 1;

        if (user.gender == "Male") {
          genderGroupAnalysis["Male"] =
              (genderGroupAnalysis["Male"] ?? 0) + compatibility;
          genderDivisor[0] += 1;
        } else {
          genderGroupAnalysis["Female"] =
              (genderGroupAnalysis["Female"] ?? 0) + compatibility;
          genderDivisor[1] += 1;
        }
      } else if (user.age > 43 && user.age < 51) {
        ageGroupAnalysis["44-50"] =
            (ageGroupAnalysis["44-50"] ?? 0) + compatibility;
        ageDivisor[4] += 1;

        if (user.gender == "Male") {
          genderGroupAnalysis["Male"] =
              (genderGroupAnalysis["Male"] ?? 0) + compatibility;
          genderDivisor[0] += 1;
        } else {
          genderGroupAnalysis["Female"] =
              (genderGroupAnalysis["Female"] ?? 0) + compatibility;
          genderDivisor[1] += 1;
        }
      } else if (user.age > 36 && user.age < 44) {
        ageGroupAnalysis["37-43"] =
            (ageGroupAnalysis["37-43"] ?? 0) + compatibility;
        ageDivisor[3] += 1;

        if (user.gender == "Male") {
          genderGroupAnalysis["Male"] =
              (genderGroupAnalysis["Male"] ?? 0) + compatibility;
          genderDivisor[0] += 1;
        } else {
          genderGroupAnalysis["Female"] =
              (genderGroupAnalysis["Female"] ?? 0) + compatibility;
          genderDivisor[1] += 1;
        }
      } else if (user.age > 29 && user.age < 37) {
        ageGroupAnalysis["30-36"] =
            (ageGroupAnalysis["30-36"] ?? 0) + compatibility;
        ageDivisor[2] += 1;

        if (user.gender == "Male") {
          genderGroupAnalysis["Male"] =
              (genderGroupAnalysis["Male"] ?? 0) + compatibility;
          genderDivisor[0] += 1;
        } else {
          genderGroupAnalysis["Female"] =
              (genderGroupAnalysis["Female"] ?? 0) + compatibility;
          genderDivisor[1] += 1;
        }
      } else if (user.age > 22 && user.age < 30) {
        ageGroupAnalysis["23-29"] =
            (ageGroupAnalysis["23-29"] ?? 0) + compatibility;
        ageDivisor[1] += 1;

        if (user.gender == "Male") {
          genderGroupAnalysis["Male"] =
              (genderGroupAnalysis["Male"] ?? 0) + compatibility;
          genderDivisor[0] += 1;
        } else {
          genderGroupAnalysis["Female"] =
              (genderGroupAnalysis["Female"] ?? 0) + compatibility;
          genderDivisor[1] += 1;
        }
      } else {
        ageGroupAnalysis["16-22"] =
            (ageGroupAnalysis["16-22"] ?? 0) + compatibility;
        ageDivisor[0] += 1;

        if (user.gender == "Male") {
          genderGroupAnalysis["Male"] =
              (genderGroupAnalysis["Male"] ?? 0) + compatibility;
          genderDivisor[0] += 1;
        } else {
          genderGroupAnalysis["Female"] =
              (genderGroupAnalysis["Female"] ?? 0) + compatibility;
          genderDivisor[1] += 1;
        }
      }
    }
    int index = 0;
    genderGroupAnalysis.updateAll((key, value) {
      int updatedValue = value;
      if (genderDivisor[index] > 0) {
        updatedValue = value ~/ genderDivisor[index];
      }
      index++;
      return updatedValue;
    });
    index = 0;
    ageGroupAnalysis.updateAll((key, value) {
      int updatedValue = value;
      if (ageDivisor[index] > 0) {
        updatedValue = value ~/ ageDivisor[index];
      }
      index++;
      return updatedValue;
    });

    return AnalysisData(
        ageGroupAnalysis: ageGroupAnalysis,
        genderGroupAnalysis: genderGroupAnalysis);
  }

  Future<List<Chat>> searchChats(String ownerId, String otherUserName) async {
    List<Chat> chats = [];
    var query1 = await chatCollection
        .where('user1UserId', isEqualTo: ownerId)
        .where('user2UserName', isGreaterThanOrEqualTo: otherUserName)
        .where('user2UserName', isLessThan: '${otherUserName}z')
        .get();

    var query2 = await chatCollection
        .where('user2UserId', isEqualTo: ownerId)
        .where('user1UserName', isGreaterThanOrEqualTo: otherUserName)
        .where('user1UserName', isLessThan: '${otherUserName}z')
        .get();

    List<QueryDocumentSnapshot> docs = query1.docs + query2.docs;
    if (docs.isEmpty) {
      return chats;
    } else {
      for (QueryDocumentSnapshot snapshot in docs) {
        chats.add(Chat.fromDocumentSnapshot(snapshot));
      }
      return chats;
    }
  }
}

class AnalysisData {
  final Map<String, int> ageGroupAnalysis;
  final Map<String, int> genderGroupAnalysis;

  AnalysisData(
      {required this.ageGroupAnalysis, required this.genderGroupAnalysis});
}
