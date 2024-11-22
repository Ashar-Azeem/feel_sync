import 'package:feel_sync/Routes/RouteNames.dart';
import 'package:feel_sync/Views/MainUI.dart';
import 'package:feel_sync/Views/Signup.dart';
import 'package:feel_sync/Views/login.dart';
import 'package:feel_sync/main.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case RouteNames.registeration:
        return MaterialPageRoute(builder: (context) => const SignupView());
      case RouteNames.mainUI:
        return MaterialPageRoute(builder: (context) => const MainUI());
      case RouteNames.initRoute:
        return MaterialPageRoute(builder: (context) => const Main());
      default:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
              body: Center(
            child: Text("Can't find the route"),
          ));
        });
    }
  }
}
