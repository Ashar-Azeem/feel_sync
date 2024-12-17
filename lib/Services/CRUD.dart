import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Models/user.dart';

class Crud {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

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

  Future<Chat> createChat({
    required User ownerUser,
    required User otherUser,
  }) async {
    try {
      // Reference to the Firestore collection
      final chatCollection = FirebaseFirestore.instance.collection('chats');

      // Prepare the data to be added
      final chatData = {
        'user1UserId': ownerUser.userId,
        'user1UserName': ownerUser.userName,
        'user1FCMToken': ownerUser.token,
        'user1ProfileLoc': ownerUser.profileLocation,
        'user2UserId': otherUser.userId,
        'user2UserName': otherUser.userName,
        'user2FCMToken': otherUser.token,
        'user2ProfileLoc': otherUser.profileLocation,
        'user1Seen': false,
        'user2Seen': false,
        'compatibility': 0,
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
      };

      // Add the data to Firestore and get the document reference
      DocumentReference docRef = await chatCollection.add(chatData);

      // Return a Chat object without fetching it
      Chat chat = Chat(
        chatId: docRef.id, // Use the document ID directly
        user1UserId: ownerUser.userId,
        user1UserName: ownerUser.userName,
        user1FCMToken: ownerUser.token,
        user1ProfileLoc: ownerUser.profileLocation,
        user2UserId: otherUser.userId,
        user2UserName: otherUser.userName,
        user2FCMToken: otherUser.token,
        user2ProfileLoc: otherUser.profileLocation,
        user1Seen: false,
        user2Seen: false,
        compatibility: 0,
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
      );
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
}
