import 'package:feel_sync/Services/AuthExceptions.dart';
import 'package:feel_sync/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  User? getUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<User?> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = getUser();
      if (user != null) {
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getFirebaseAuthErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = getUser();
      if (user != null) {
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getFirebaseAuthErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
