import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  // textStyles
  final titleFont = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final subtitleFont = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  final botFont = const TextStyle(fontSize: 16, color: Colors.white);
  final botFont2 = const TextStyle(fontSize: 16, color: Colors.black);

  Widget signInButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text(
            "Register",
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
      backgroundColor: const Color.fromARGB(255, 37, 233, 233),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 88, right: 88, bottom: 4),
                child: Center(child: Lottie.asset("assets/create_acc.json")),
              ),
              Text(
                'Sign up',
                style: GoogleFonts.fjallaOne(
                  textStyle: titleFont,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Create an account, its free! ",
                style: GoogleFonts.fjallaOne(
                  textStyle: botFont,
                ),
              ),
              const SizedBox(height: 10),
              // username
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, left: 15, right: 15, bottom: 5),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Username'),
                    ),
                  ),
                ),
              ),
              // password
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, left: 15, right: 15, bottom: 5),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Password'),
                    ),
                  ),
                ),
              ),
              // sign in button
              signInButton(),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already own an account? ",
                    style: GoogleFonts.fjallaOne(
                      textStyle: botFont,
                    ),
                  ),
                  Text(
                    "Login",
                    style: GoogleFonts.fjallaOne(
                      textStyle: botFont2,
                    ),
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
