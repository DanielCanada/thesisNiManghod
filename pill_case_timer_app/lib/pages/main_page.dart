import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_case_timer_app/models/user_profile.dart';
import 'package:pill_case_timer_app/pages/aux_pages/under_dev.dart';
import 'package:pill_case_timer_app/pages/calendar/calendar_events.dart';
import 'package:pill_case_timer_app/pages/schedule_page.dart';
import 'package:pill_case_timer_app/pages/settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // current user
  final user = FirebaseAuth.instance.currentUser!;
  late String userName = user.email.toString();
  late List<String> name = userName.split('@');
  // Current User
  late UserProfile currentUser;
  bool gotUser = false;

  // get user
  Future<UserProfile?> getProfile() async {
    final specSched =
        FirebaseFirestore.instance.collection('users').doc(name[0]);

    final snapshot = await specSched.get();

    if (snapshot.exists) {
      gotUser = true;
      currentUser = UserProfile.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    getProfile().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  // style of title
  final titleFont = const TextStyle(fontSize: 60, fontWeight: FontWeight.bold);

  final buttonFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final versionFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  // button widget - diri lang edit kung ano ang gusto niyo nga button
  Widget buildButton(String label) => SizedBox(
        height: 60,
        width: 140,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextButton(
            onPressed: () {
              if (label == 'Schedules') {
                debugPrint('$label Clicked');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SchedulePage(
                          name: name[0].toString(),
                        )));
              } else if (label == 'Logs') {
                debugPrint('$label Clicked');
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LogsPage()));
              } else {
                debugPrint('$label Clicked');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UnderDevelopment()));
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: const BorderSide(width: 4.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(0)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 132, 145, 218)),
            ),
            child: Text(
              label,
              style: GoogleFonts.amaticSc(
                textStyle: buttonFont,
              ),
            ),
          ),
        ),
      );

  Widget buildSettingsIcon() => SizedBox(
        height: 60,
        width: 66,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(
                        docName: name[0],
                      )));
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: const BorderSide(width: 4.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(0)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 132, 145, 218)),
            ),
            child: const Icon(Icons.settings, color: Colors.black),
          ),
        ),
      );

  Widget buildSignOutIcon() => SizedBox(
        height: 60,
        width: 66,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: const BorderSide(width: 4.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(0)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 132, 145, 218)),
            ),
            child: const Icon(Icons.logout_outlined, color: Colors.black),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 233, 233),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0, left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    'PILL',
                    style: GoogleFonts.amaticSc(
                      textStyle: titleFont,
                    ),
                  ),
                  Text(
                    'CASE',
                    style: GoogleFonts.amaticSc(
                      textStyle: titleFont,
                    ),
                  ),
                  Text(
                    'TIMER',
                    style: GoogleFonts.amaticSc(
                      textStyle: titleFont,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // schedule button
                  buildButton("Schedules"),
                  // Log button
                  buildButton("Logs"),
                  // Containers button
                  buildButton("Containers"),
                  // settings and signout?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Settings button
                      buildSettingsIcon(),
                      const SizedBox(width: 10),
                      // Settings button
                      buildSignOutIcon(),
                    ],
                  ),
                  // button decoration including image and version #
                  Container(
                    alignment: const Alignment(0, 0.9),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Image(
                            image: AssetImage('assets/hello_patients_01.png'),
                            height: 190,
                            width: 190,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                "Welcome!",
                                style: GoogleFonts.amaticSc(
                                  textStyle: buttonFont,
                                ),
                              ),
                              Text(
                                gotUser == false
                                    ? "User"
                                    : "${currentUser.firstName.toString()} ${currentUser.lastName.toString()}",
                                style: GoogleFonts.amaticSc(
                                  textStyle: buttonFont,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
