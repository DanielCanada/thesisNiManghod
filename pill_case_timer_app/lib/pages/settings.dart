import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/user_profile.dart';
import 'package:pill_case_timer_app/pages/about.dart';
import 'package:pill_case_timer_app/pages/aux_pages/went_wrong_page.dart';

class SettingsPage extends StatefulWidget {
  final String docName;
  const SettingsPage({Key? key, required this.docName}) : super(key: key);

  @override
  State<SettingsPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SettingsPage> {
  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final titleFont = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);

  final bodyFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  final footerFont = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);

  TextStyle buttonFont(int x) => TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: x > 0 ? Colors.red : const Color.fromARGB(255, 0, 140, 255));

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController ageController;

  // gender & age
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String? selectedGender;
  bool newGender = false;
  bool isActivated = false;

  @override
  void initState() {
    super.initState();
  }

  // get user
  Future<UserProfile?> getUserDetails() async {
    final specSched =
        FirebaseFirestore.instance.collection('users').doc(widget.docName);

    final snapshot = await specSched.get();

    if (snapshot.exists) {
      return UserProfile.fromJson(snapshot.data()!);
    }
  }

  // create to firebase
  Future updateUserProfile(
      String firstName, String lastName, UserProfile oldUser) async {
    try {
      final docSched =
          FirebaseFirestore.instance.collection("users").doc(widget.docName);

      final updatedUser = UserProfile(
          age: int.parse(ageController.text.trim()),
          email: oldUser.email.toString(),
          firstName: firstName,
          gender: newGender == false
              ? oldUser.gender.toString()
              : selectedGender.toString(),
          lastName: lastName,
          deviceActivated: isActivated);

      final json = updatedUser.toJson();

      await docSched.update(json);

      setState(() {
        getUserDetails();
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      const invalidUser = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Oops! Kindly review your details and try again'),
      );
      ScaffoldMessenger.of(context).showSnackBar(invalidUser);
    }
  }

  Future<void> _showEditProfileDialog(UserProfile? user) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Lottie.asset('assets/sparkles_01.json', fit: BoxFit.contain),
              AlertDialog(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Profile",
                      style: GoogleFonts.amaticSc(textStyle: titleFont),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      // First Name
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextFormField(
                            style: GoogleFonts.amaticSc(textStyle: titleFont),
                            controller: firstNameController =
                                TextEditingController(
                                    text: user!.firstName.toString()),
                            decoration: InputDecoration(
                                suffixIcon: firstNameController.text.isEmpty
                                    ? Container(
                                        width: 0,
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 26.0),
                                        child: IconButton(
                                            icon: const Icon(
                                              Iconsax.close_square,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              firstNameController.clear();
                                            }),
                                      ),
                                border: InputBorder.none,
                                hintText: '',
                                labelText: "First Name:"),
                          ),
                        ),
                      ),
                      // last Name
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: GoogleFonts.amaticSc(textStyle: titleFont),
                          controller: lastNameController =
                              TextEditingController(
                                  text: user.lastName.toString()),
                          decoration: InputDecoration(
                              suffixIcon: lastNameController.text.isEmpty
                                  ? Container(
                                      width: 0,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 26.0),
                                      child: IconButton(
                                          icon: const Icon(
                                            Iconsax.close_square,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            lastNameController.clear();
                                          }),
                                    ),
                              border: InputBorder.none,
                              hintText: '',
                              labelText: "Last Name:"),
                        ),
                      ),
                      // age
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          style: GoogleFonts.amaticSc(textStyle: titleFont),
                          controller: ageController =
                              TextEditingController(text: user.age.toString()),
                          decoration: InputDecoration(
                              suffixIcon: ageController.text.isEmpty
                                  ? Container(
                                      width: 0,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 26.0),
                                      child: IconButton(
                                          icon: const Icon(
                                            Iconsax.close_square,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            ageController.clear();
                                          }),
                                    ),
                              border: InputBorder.none,
                              hintText: '',
                              labelText: "Age:"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "  Gender:",
                              style: GoogleFonts.amaticSc(
                                textStyle: bodyFont,
                              ),
                            ),
                            DropdownButtonFormField2(
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
                                user.gender.toString(),
                                style: GoogleFonts.amaticSc(
                                  textStyle: bodyFont,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.deepOrange,
                              ),
                              iconSize: 30,
                              buttonHeight: 50,
                              buttonPadding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              items: genderItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: GoogleFonts.amaticSc(
                                            textStyle: bodyFont,
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
                                newGender = true;
                              },
                              onSaved: (value) {
                                selectedGender = value.toString();
                                newGender = true;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.amaticSc(
                        textStyle: buttonFont(1),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Save",
                      style: GoogleFonts.amaticSc(
                        textStyle: buttonFont(0),
                      ),
                    ),
                    onPressed: () {
                      updateUserProfile(firstNameController.text.trim(),
                          lastNameController.text.trim(), user);
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 233, 233),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder<UserProfile?>(
              future: getUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SomethingWentWrong();
                } else if (snapshot.hasData) {
                  isActivated = snapshot.data!.deviceActivated;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        child: OverflowBox(
                          minHeight: 170,
                          maxHeight: 170,
                          child: snapshot.data!.gender.toString() == "Female"
                              ? Lottie.asset(
                                  'assets/female_01.json',
                                )
                              : Lottie.asset(
                                  'assets/male_01.json',
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${snapshot.data!.firstName.toString()} ${snapshot.data!.lastName.toString()}",
                        style: GoogleFonts.amaticSc(textStyle: bodyFont),
                      ),
                      Text(
                        snapshot.data!.email.toString(),
                        style: GoogleFonts.amaticSc(textStyle: bodyFont),
                      ),
                      Text(
                        snapshot.data!.age.toString(),
                        style: GoogleFonts.amaticSc(textStyle: bodyFont),
                      ),
                      Text(
                        snapshot.data!.gender.toString(),
                        style: GoogleFonts.amaticSc(textStyle: bodyFont),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 90),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showEditProfileDialog(snapshot.data);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 2,
                                color: Colors.white, // red as border color
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.edit, color: Colors.black),
                                const SizedBox(width: 10),
                                Text(
                                  "Update Details",
                                  style:
                                      GoogleFonts.amaticSc(textStyle: bodyFont),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 4,
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AboutPage())),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, right: 50),
                              child: Lottie.asset("assets/team.json"),
                            ),
                            Text(
                              "Get to know the people behind the idea!",
                              style: GoogleFonts.amaticSc(textStyle: titleFont),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 4,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          "Copyright © 2022 Thesis Development Co. All rights reserved.",
                          style: GoogleFonts.amaticSc(textStyle: footerFont),
                        ),
                      ),
                      const Divider(
                        thickness: 4,
                        color: Colors.white,
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Lottie.asset("assets/loading02.json"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
