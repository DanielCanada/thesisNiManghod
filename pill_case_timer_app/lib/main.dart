import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pill_case_timer_app/pages/initial_main_page.dart';
import 'package:pill_case_timer_app/pages/onBoarding%20pages/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final showAuth = prefs.getBool('showAuth') ?? false;

  runApp(MyApp(showAuth: showAuth));
}

class MyApp extends StatelessWidget {
  final bool showAuth;
  const MyApp({Key? key, required this.showAuth}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(),
      home: showAuth ? const InitialMainPage() : const OnBoardingScreen(),
    );
  }
}
