import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/pages/aux_pages/second_screen.dart';
// import 'package:pill_case_timer_app/pages/aux_pages/under_dev.dart';
import 'package:pill_case_timer_app/pages/calendar/api/notifications_api.dart';
import 'package:pill_case_timer_app/pages/calendar/calendar_carousel.dart';
import 'package:pill_case_timer_app/pages/container_page/container_page.dart';
import 'package:pill_case_timer_app/pages/schedule_page.dart';
import 'package:pill_case_timer_app/pages/settings.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pill_case_timer_app/widgets/fade_indexed_stack.dart';
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
  final titleFont = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  final titleFont2 = const TextStyle(fontSize: 38, fontWeight: FontWeight.bold);

  final buttonFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final versionFont = const TextStyle(fontSize: 12, color: Colors.black);
  final versionFont2 = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  final versionFont3 = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);

  var _bottomNavIndex = 0;
  final DateTime now = DateTime.now();
  final cardHeight = 360;

  late final LocalNotificationService service;

  late String dateName = DateFormat('EEEE').format(now);
  String genderOfUser = "";
  bool isChecked = false;

  Stream<List<Schedule>> getSchedules() => FirebaseFirestore.instance
      .collection('patients')
      .doc(name[0])
      .collection("schedules")
      .orderBy("alarmTime", descending: false)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Schedule.fromJson(doc.data())).toList());

  @override
  void initState() {
    // assert(now.weekday == DateTime.monday);
    super.initState();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    // getUserDetails();
  }

  final iconList = <IconData>[
    Iconsax.home_2,
    Iconsax.document_text4,
    Iconsax.calendar_1,
    Iconsax.box,
  ];

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => SecondScreen(payload: payload))));
    }
  }

  Widget checkForActivitiesToday(List<Schedule> schedules) {
    List<Schedule> todayScheds = [];
    int hasSchedule = 0;
    for (int i = 0; i < schedules.length; i++) {
      var element = schedules[i];
      if (element.schedDate.contains(dateName)) {
        hasSchedule++;
        todayScheds.add(element);
      }
    }
    if (hasSchedule == 0) {
      return buildEmptyActivities();
    } else {
      return Expanded(
          child: ListView(children: todayScheds.map(buildSchedules).toList()));
    }
  }

  Widget buildMainScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 148, 215, 231),
      body: SingleChildScrollView(
        child: SafeArea(
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
                      GestureDetector(
                        onTap: () async {
                          await service.showScheduledNotification(
                            id: 0,
                            title: 'Todays Medications Notification Alert',
                            body: 'Content of the notification alert',
                            time:
                                DateTime.now().add(const Duration(seconds: 10)),
                          );
                        },
                        child: Text(
                          "Todays Medications",
                          style: GoogleFonts.aBeeZee(
                            textStyle: buttonFont,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<List<Schedule>>(
                        stream: getSchedules(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return buildEmptyActivities();
                          } else if (snapshot.hasData) {
                            final schedules = snapshot.data!;
                            if (schedules.isEmpty) {
                              return buildEmptyActivities();
                            } else {
                              return checkForActivitiesToday(schedules);
                            }
                          } else {
                            return Center(
                                child: Lottie.asset("assets/loading02.json"));
                          }
                        },
                      ),
                      // buildEmptyActivities()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSchedules(Schedule sched) {
    UniqueKey key = UniqueKey();
    debugPrint(key.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TodayCard(
        key: key,
        label: sched.schedName,
        alarmTime: sched.alarmTime,
        containerNum: sched.containerNum,
        isChecked: isChecked,
        onChanged: (value) {
          setState(() {
            isChecked = value;
            DateTime date = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                sched.alarmTime.hour,
                sched.alarmTime.minute);
            debugPrint(date.toString());
            service.showScheduledNotification(
              id: 0,
              title: sched.schedName,
              body: 'Medicine dropped at container#${sched.containerNum}',
              time: date,
            );
          });
        },
      ),
    );
  }

  Widget buildEmptyActivities() {
    return SizedBox(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Text(
                "No scheduled meds for today.",
                style: GoogleFonts.aBeeZee(
                  textStyle: versionFont3,
                ),
              ),
            ),
          ),
          Center(
              child: SizedBox(
            height: 250,
            width: 300,
            child: Lottie.asset('assets/empty.json', fit: BoxFit.fill),
          )),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 205.0),
              child: Text(
                "Feel free to chill!",
                style: GoogleFonts.aBeeZee(
                  textStyle: versionFont3,
                ),
              ),
            ),
          ),
        ],
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
            padding: const EdgeInsets.only(top: 130.0),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      (now.hour > 12 && now.hour < 18)
                          ? "Good Afternoon,"
                          : now.hour > 18
                              ? "Good Evening,"
                              : "Good Morning,",
                      style: GoogleFonts.aBeeZee(
                        textStyle: titleFont,
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(name[0])
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          "Guest",
                          style: GoogleFonts.aBeeZee(
                            textStyle: buttonFont,
                          ),
                        );
                      }
                      var userDocument = snapshot.data;
                      genderOfUser = snapshot.data!["gender"].toString();
                      // add to userProfile for calendar and pdf
                      // userProfile = UserProfile(
                      //     firstName: snapshot.data!["firstName"].toString(),
                      //     lastName: snapshot.data!["lastName"].toString(),
                      //     age: snapshot.data!["age"],
                      //     gender: snapshot.data!["gender"].toString(),
                      //     email: snapshot.data!["email"].toString());
                      return Text(
                        userDocument![
                            "firstName"] /* +
                              " " +
                              userDocument["lastName"]*/
                        ,
                        style: GoogleFonts.aBeeZee(
                          textStyle: titleFont2,
                        ),
                      );
                    }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 14.0, left: (MediaQuery.of(context).size.width - 100)),
            child: GestureDetector(
              onTap: () {
                debugPrint(dateName);
                // profile
                setState(() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsPage(docName: name[0])));
                });
              },
              child: SizedBox(
                height: 80,
                width: 80,
                child: genderOfUser == "Female"
                    ? Lottie.asset('assets/female_01.json', fit: BoxFit.cover)
                    : Lottie.asset('assets/male_01.json', fit: BoxFit.cover),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 76.0, left: 40.0),
            child: Image(
              image: AssetImage('assets/hello_patients_01.png'),
              height: 240,
              width: 240,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          (_bottomNavIndex == 0 || _bottomNavIndex == 2 || _bottomNavIndex == 3)
              ? Colors.transparent
              : const Color.fromARGB(255, 37, 233, 233),
      body: GestureDetector(
        onHorizontalDragEnd: (dragEndDetails) {
          int sensitivity = 8;
          // Swiping in right direction.
          if (dragEndDetails.primaryVelocity! > 0) {
            if (_bottomNavIndex >= 1 && _bottomNavIndex <= 3) {
              setState(() {
                _bottomNavIndex--;
              });
              print(_bottomNavIndex);
            } else {}
          }

          // Swiping in left direction.
          else if (dragEndDetails.primaryVelocity! < 0) {
            if (_bottomNavIndex >= 0 && _bottomNavIndex < 3) {
              setState(() {
                _bottomNavIndex++;
              });
              print(_bottomNavIndex);
            } else {}
          }
        },
        child: FadeIndexedStack(
          index: _bottomNavIndex,
          children: <Widget>[
            buildMainScreen(context),
            SchedulePage(name: name[0]),
            NewCalendar(
              docName: name[0],
            ),
            ContainerPage(
              docID: name[0],
            ),
          ],
        ),
      ), //destination screen
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: (_bottomNavIndex == 1)
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

  Future buildModal() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Stack(
            children: [
              Lottie.asset('assets/background_01.json', fit: BoxFit.fill),
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
                    leading: const Icon(Icons.videocam),
                    title: const Text('Video'),
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
  }
}
