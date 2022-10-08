import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/user_profile.dart';

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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  // usernameindb
  late String userName = _emailController.text;
  late List<String> name = userName.split('@');

  // gender & age
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String? selectedGender;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        // add user details
        addUserDetails(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            int.parse(_ageController.text.trim()),
            selectedGender.toString(), // gender
            _emailController.text.trim());
      } else {
        const passNotTheSame = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Oops! Your passwords does not match'),
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(passNotTheSame);
      }
    } catch (e) {
      const invalidUser = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Oops! Kindly review your details and try again'),
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(invalidUser);
    }
  }

  Future addUserDetails(String firstName, String lastName, int age,
      String gender, String email) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc(name[0]);

    final newUser = UserProfile(
        firstName: firstName,
        lastName: lastName,
        age: age,
        gender: gender,
        email: email);

    await docUser.set(newUser.toJson());
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
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 10, left: 20, right: 20),
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 90, right: 90),
                //   child: Center(child: Lottie.asset("assets/create_acc.json")),
                // ),
                const SizedBox(height: 6),
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

                // names
                Padding(
                  padding: const EdgeInsets.only(left: 10),
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: ''),
                      ),
                    ),
                  ),
                ),
                //last name
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 2),
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: ''),
                      ),
                    ),
                  ),
                ),

                // age
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Age',
                        style: GoogleFonts.fjallaOne(
                          textStyle: labelFont,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: ''),
                      ),
                    ),
                  ),
                ),

                // gender
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: GoogleFonts.fjallaOne(
                          textStyle: labelFont,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 2, right: 10, bottom: 2),
                  child: DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: false,
                      contentPadding: EdgeInsets.zero,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.deepOrange,
                              width: 2,
                              style: BorderStyle.solid)),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    hint: Text(
                      'Select Your Gender...',
                      style: GoogleFonts.fjallaOne(
                        textStyle: labelFont,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.deepOrange,
                    ),
                    iconSize: 30,
                    buttonHeight: 50,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: genderItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: GoogleFonts.fjallaOne(
                                  textStyle: labelFont,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                    },
                    onChanged: (value) {
                      //Do something when changing the item if you want.
                      selectedGender = value.toString();
                    },
                    onSaved: (value) {
                      selectedGender = value.toString();
                    },
                  ),
                ),

                // email
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 2),
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                  padding: const EdgeInsets.only(left: 10, top: 2),
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                  padding: const EdgeInsets.only(left: 10, top: 2),
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
