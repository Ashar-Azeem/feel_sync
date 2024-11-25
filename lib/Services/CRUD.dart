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
}
