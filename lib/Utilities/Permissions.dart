import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> requestNotificationPermission() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if permission has already been requested
  bool hasRequestedPermission =
      prefs.getBool('hasRequestedPermission') ?? false;

  if (!hasRequestedPermission) {
    // Request notification permission
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();

    // Update the flag in SharedPreferences
    await prefs.setBool('hasRequestedPermission', true);
  }
}
