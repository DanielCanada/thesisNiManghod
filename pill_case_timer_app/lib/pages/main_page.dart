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
import 'package:pill_case_timer_app/widgets/today_card.dart';

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
  final titleFont2 = const TextStyle(fontSize: 38, fontWeight: FontWeight.bold);

  final buttonFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final versionFont = const TextStyle(fontSize: 12, color: Colors.black);
  final versionFont2 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  var _bottomNavIndex = 0;
  final DateTime now = DateTime.now();
  final cardHeight = 320;

  @override
  void initState() {
    assert(now.weekday == DateTime.sunday);
    super.initState();
  }

  final iconList = <IconData>[
    Iconsax.home_2,
    Iconsax.document_text4,
    Iconsax.calendar_1,
    Iconsax.box,
    Iconsax.profile_circle,
  ];

  Widget buildMainScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 148, 215, 231),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPreviewsTab(context),
              Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height - cardHeight.toDouble(),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Today's Activities",
                        style: GoogleFonts.aBeeZee(
                          textStyle: buttonFont,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: TodayCard(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // SchedulePage(name: name[0])
            ],
          ),
        ),
      ),
    );
  }

  Container buildPreviewsTab(BuildContext context) {
    return Container(
      height: cardHeight.toDouble(),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 148, 215, 231),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Container(
              height: cardHeight.toDouble(),
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
                  padding: const EdgeInsets.only(top: 82.0),
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
                          textStyle: buttonFont,
                        ),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(name[0])
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Text(
                                "Guest",
                                style: GoogleFonts.aBeeZee(
                                  textStyle: buttonFont,
                                ),
                              );
                            }
                            var userDocument = snapshot.data;
                            return Text(
                              userDocument!["firstName"] +
                                  " " +
                                  userDocument["lastName"],
                              style: GoogleFonts.amaticSc(
                                textStyle: buttonFont,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Text(
                  "Pill Case Timer",
                  style: GoogleFonts.aBeeZee(
                    textStyle: titleFont2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14.0, right: 16),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Stack(
                            children: [
                              Lottie.asset('assets/background_01.json',
                                  fit: BoxFit.fill),
                              Column(
                                mainAxisSize: MainAxisSize.values.last,
                                children: [
                                  ListTile(
                                    leading: new Icon(Icons.photo),
                                    title: new Text('Photo'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.music_note),
                                    title: new Text('Music'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.videocam),
                                    title: new Text('Video'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.share),
                                    title: new Text('Share'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
                  },
                  child: Lottie.asset('assets/med_bottle_01.json',
                      height: 50, width: 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (_bottomNavIndex == 0 || _bottomNavIndex == 2)
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
        heroTag: null,
        backgroundColor: (_bottomNavIndex == 1 ||
                _bottomNavIndex == 3 ||
                _bottomNavIndex == 4)
            ? Colors.white
            : const Color.fromARGB(255, 37, 233, 233),
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
