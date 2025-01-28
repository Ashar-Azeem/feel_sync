import 'package:feel_sync/Routes/RouteNames.dart';
import 'package:feel_sync/Routes/Routing.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Utilities/Permissions.dart';
import 'package:feel_sync/Views/MainUI.dart';
import 'package:feel_sync/Views/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromARGB(255, 6, 6, 14)));
  await requestNotificationPermission();
  runApp(Sizer(builder: (context, orientation, screenType) {
    return MaterialApp(
      title: 'FeelSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 12, 138, 211),
            brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color.fromARGB(255, 12, 15, 20),
        useMaterial3: true,
      ),
      initialRoute: RouteNames.initRoute,
      onGenerateRoute: Routes.generateRoutes,
    );
  }));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService().initialize(),
        builder: (
          context,
          snapshot,
        ) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                if (AuthService().getUser() == null) {
                  return const LoginView();
                } else {
                  return const MainUI();
                }
              }
            default:
              {
                return const Scaffold(
                    body: Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                ));
              }
          }
        });
  }
}