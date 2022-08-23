import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({Key? key, required this.showLoginPage}) : super(key: key);

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

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      } else {
        const passNotTheSame = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Oops! Your passwords does not match'),
        );
        ScaffoldMessenger.of(context).showSnackBar(passNotTheSame);
      }
    } catch (e) {
      const invalidUser = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Oops! Kindly review your details and try again'),
      );
      ScaffoldMessenger.of(context).showSnackBar(invalidUser);
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

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
            "Sign Up",
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
                  'HELLO THERE',
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

                // email
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: ''),
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: ''),
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
                        'Confirm Password',
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: ''),
                      ),
                    ),
                  ),
                ),
                // sign in button
                GestureDetector(
                    onTap: () {
                      signUp();
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
                      onTap: widget.showLoginPage,
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

// // names
                // Padding(
                //   padding: const EdgeInsets.only(left: 18),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text(
                //         'First name',
                //         style: GoogleFonts.fjallaOne(
                //           textStyle: labelFont,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.grey[200],
                //       border: Border.all(color: Colors.white),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: const Padding(
                //       padding: EdgeInsets.only(left: 10, right: 10),
                //       child: TextField(
                //         decoration: InputDecoration(
                //             border: InputBorder.none, hintText: ''),
                //       ),
                //     ),
                //   ),
                // ),
                // //last name
                // Padding(
                //   padding: const EdgeInsets.only(left: 18, top: 2),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Last name',
                //         style: GoogleFonts.fjallaOne(
                //           textStyle: labelFont,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.grey[200],
                //       border: Border.all(color: Colors.white),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: const Padding(
                //       padding: EdgeInsets.only(left: 10, right: 10),
                //       child: TextField(
                //         decoration: InputDecoration(
                //             border: InputBorder.none, hintText: ''),
                //       ),
                //     ),
                //   ),
                // ),