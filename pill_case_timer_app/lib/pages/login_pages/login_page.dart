import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/pages/login_pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // textStyles
  final titleFont = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final subtitleFont = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
  final botFont = const TextStyle(fontSize: 16, color: Colors.black);
  final botFont2 = const TextStyle(fontSize: 16, color: Colors.white);

  Widget signInButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text(
            "Sign In",
            style: GoogleFonts.fjallaOne(
              textStyle: subtitleFont,
            ),
          )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 132, 145, 218),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 24.0, left: 100, right: 100, bottom: 4),
                child: Center(child: Lottie.asset("assets/user-profile.json")),
              ),
              Text(
                'Hello, Welcome back!',
                style: GoogleFonts.fjallaOne(
                  textStyle: titleFont,
                ),
              ),
              const SizedBox(height: 14),
              // username
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: GoogleFonts.fjallaOne(
                        textStyle: botFont,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Username'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // password
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: GoogleFonts.fjallaOne(
                        textStyle: botFont,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, left: 25, right: 25, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: '**********'),
                    ),
                  ),
                ),
              ),
              // sign in button
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SignupPage();
                        },
                      ),
                    );
                  },
                  child: signInButton()),
              // not a member? register now
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: GoogleFonts.fjallaOne(
                        textStyle: botFont,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignupPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Register now",
                        style: GoogleFonts.fjallaOne(
                          textStyle: botFont2,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
