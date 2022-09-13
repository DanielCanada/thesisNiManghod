import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 120, right: 120),
                        child: GestureDetector(
                          onTap: () {},
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
                      const SizedBox(height: 10),
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
