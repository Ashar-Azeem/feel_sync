import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_sync/Models/user.dart';

class Crud {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
}
