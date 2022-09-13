import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/user_profile.dart';
import 'package:pill_case_timer_app/pages/aux_pages/under_dev.dart';
import 'package:pill_case_timer_app/pages/calendar/calendar_events.dart';
import 'package:pill_case_timer_app/pages/main_screen.dart';
import 'package:pill_case_timer_app/pages/schedule_page.dart';
import 'package:pill_case_timer_app/pages/settings.dart';
import 'package:iconsax/iconsax.dart';

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
  // style of title
  final titleFont = const TextStyle(fontSize: 60, fontWeight: FontWeight.bold);

  final buttonFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final versionFont = const TextStyle(fontSize: 12, color: Colors.black);
  final versionFont2 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  var _bottomNavIndex = 0;
  final DateTime now = DateTime.now();

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

  final iconList = <IconData>[
    Iconsax.home_2,
    Iconsax.document_text4,
    Iconsax.calendar_1,
    Iconsax.box,
    Iconsax.personalcard,
  ];

  Widget buildMainScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.15),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 16.0, left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPreviewsTab(context),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Text(
                    "Schedules",
                    style: GoogleFonts.aBeeZee(
                      textStyle: buttonFont,
                    ),
                  ),
                ),
                // SchedulePage(name: name[0])
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildPreviewsTab(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 148, 215, 231),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage("assets/med_collection.jpg"),
                      fit: BoxFit.fitWidth),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        now.hour > 12
                            ? "Good Afternoon, "
                            : now.hour > 18
                                ? "Good Evening,"
                                : "Good Morning,",
                        style: GoogleFonts.amaticSc(
                          textStyle: versionFont2,
                        ),
                      ),
                      Text(
                        gotUser == false
                            ? "User"
                            : "${currentUser.firstName.toString()} ${currentUser.lastName.toString()}!",
                        style: GoogleFonts.amaticSc(
                          textStyle: buttonFont,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    "Have a great day!",
                    style: GoogleFonts.aBeeZee(
                      textStyle: versionFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(top: 50.0, left: 20),
          //       child: Lottie.asset('assets/med_bottle_01.json',
          //           height: 150, width: 175),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(top: 50.0, left: 20),
          //       child: Lottie.asset('assets/list_01.json',
          //           height: 150, width: 150),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bottomNavIndex == 0
          ? Colors.transparent
          : const Color.fromARGB(255, 37, 233, 233),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: <Widget>[
          buildMainScreen(context),
          SchedulePage(name: name[0]),
          LogsPage(),
          UnderDevelopment(),
          SettingsPage(docName: name[0])
        ],
      ), //destination screen
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 37, 233, 233),
        child: const Icon(
          Iconsax.logout_1,
          color: Colors.black,
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: const Color.fromARGB(255, 2, 75, 75),
        backgroundColor: Colors.white,
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
