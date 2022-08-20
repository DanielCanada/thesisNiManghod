import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pill_case_timer_app/pages/main_page.dart';

import 'login_pages/login_page.dart';
import 'onBoarding pages/onboarding_screen.dart';

class InitialMainPage extends StatelessWidget {
  const InitialMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MyHomePage();
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
