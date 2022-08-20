import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pill_case_timer_app/pages/login_pages/auth_change_page.dart';
import 'package:pill_case_timer_app/pages/main_page.dart';

class InitialMainPage extends StatelessWidget {
  const InitialMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MyHomePage();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
