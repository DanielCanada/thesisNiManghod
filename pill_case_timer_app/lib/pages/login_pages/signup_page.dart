import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/pages/main_page.dart';

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
  final botFont = const TextStyle(fontSize: 16, color: Colors.black);
  final labelFont = const TextStyle(fontSize: 14, color: Colors.black);
  final botFont2 = const TextStyle(fontSize: 16, color: Colors.deepOrange);

  Widget signInButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 90, right: 90),
                  child: Center(child: Lottie.asset("assets/create_acc.json")),
                ),
                Text(
                  'Sign up',
                  style: GoogleFonts.fjallaOne(
                    textStyle: titleFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Create an account, its free! ",
                  style: GoogleFonts.fjallaOne(
                    textStyle: botFont,
                  ),
                ),
                const SizedBox(height: 8),
                // names
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'First name',
                        style: GoogleFonts.fjallaOne(
                          textStyle: labelFont,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            border: InputBorder.none, hintText: 'First Name'),
                      ),
                    ),
                  ),
                ),
                //last name
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Last name',
                        style: GoogleFonts.fjallaOne(
                          textStyle: labelFont,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            border: InputBorder.none, hintText: 'Last Name'),
                      ),
                    ),
                  ),
                ),
                // username
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: GoogleFonts.fjallaOne(
                          textStyle: labelFont,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                // password
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: GoogleFonts.fjallaOne(
                          textStyle: labelFont,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            border: InputBorder.none, hintText: 'Password'),
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
                            return const MyHomePage();
                          },
                        ),
                      );
                    },
                    child: signInButton()),

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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.fjallaOne(
                          textStyle: botFont2,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
