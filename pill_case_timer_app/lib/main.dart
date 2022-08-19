import 'package:flutter/material.dart';
import 'package:pill_case_timer_app/pages/main_page.dart';
import 'package:pill_case_timer_app/pages/onBoarding%20pages/first_page.dart';
import 'package:pill_case_timer_app/pages/onBoarding%20pages/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const OnBoardingScreen(),
    );
  }
}
