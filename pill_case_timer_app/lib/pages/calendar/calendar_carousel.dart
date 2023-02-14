import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/models/user_profile.dart';
import 'package:pill_case_timer_app/pages/calendar/calendar_util.dart';
import 'api/pdf_api.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:open_file/open_file.dart';
import 'package:iconsax/iconsax.dart';

class NewCalendar extends StatefulWidget {
  final String docName;
  const NewCalendar({Key? key, required this.docName}) : super(key: key);

  @override
  State<NewCalendar> createState() => _NewCalendarState();
}

class _NewCalendarState extends State<NewCalendar> {
  final keySignaturePad = GlobalKey<SfSignaturePadState>();
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime(2023, 2, 14);
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime(2023, 2, 15);
  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  // time
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        DateTime(2023, 2, 25),
        Event(
          date: DateTime(2023, 2, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        DateTime(2023, 2, 17),
        Event(
          date: DateTime(2023, 2, 17),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(DateTime(2023, 2, 18), [
      Event(
        date: DateTime(2023, 2, 18),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2023, 2, 18),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      Event(
        date: DateTime(2023, 2, 18),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
    super.initState();
  }

  // create to firebase
  Future addPostSchedule(
      String schedName,
      String schedDate,
      String containerNum,
      String duration,
      String doctorName,
      DateTime alarmTime) async {
    final docSched = FirebaseFirestore.instance
        .collection("patients")
        .doc(widget.docName)
        .collection("finished_schedules")
        .doc();

    final newSched = Schedule(
        id: docSched.id,
        schedName: schedName,
        schedDate: schedDate,
        containerNum: containerNum,
        duration: duration,
        doctorName: doctorName,
        alarmTime: alarmTime,
        createdAt: DateTime.now());

    final json = newSched.toJson();

    await docSched.set(json);
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: (DateTime.now().hour > 12 && DateTime.now().hour < 18)
                    ? Lottie.asset('assets/background_01.json',
                        fit: BoxFit.fill)
                    : DateTime.now().hour > 18
                        ? Lottie.asset('assets/b_night.json', fit: BoxFit.fill)
                        : Lottie.asset('assets/b_early_morning.json',
                            fit: BoxFit.fill)),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      addPostSchedule(
                          "Tempra",
                          "WednesdayFriday",
                          "2",
                          "3 days",
                          "Dr. doofenshmirtz",
                          DateTime(2023, 2, 10, 15, 30));
                      debugPrint("added to postScheds");
                    },
                    child: Text(
                      "Logs",
                      style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(
                              bottom: 16.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  _currentMonth,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                )),
                                TextButton(
                                  child: const Icon(
                                    CupertinoIcons.left_chevron,
                                    color: Colors.black,
                                    size: 34,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _targetDateTime = DateTime(
                                          _targetDateTime.year,
                                          _targetDateTime.month - 1);
                                      _currentMonth = DateFormat.yMMM()
                                          .format(_targetDateTime);
                                    });
                                  },
                                ),
                                TextButton(
                                  child: const Icon(
                                    CupertinoIcons.right_chevron,
                                    color: Colors.black,
                                    size: 34,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _targetDateTime = DateTime(
                                          _targetDateTime.year,
                                          _targetDateTime.month + 1);
                                      _currentMonth = DateFormat.yMMM()
                                          .format(_targetDateTime);
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          CalendarCarousel<Event>(
                            todayBorderColor: Colors.green,
                            onDayPressed: (date, events) {
                              setState(() => _currentDate2 = date);
                              for (var event in events) {
                                print(event.title);
                              }
                            },
                            daysHaveCircularBorder: true,
                            showOnlyCurrentMonthDate: false,
                            weekendTextStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            thisMonthDayBorderColor: Colors.grey,
                            weekFormat: false,
                            //      firstDayOfWeek: 4,
                            markedDatesMap: _markedDateMap,
                            height: 350,
                            selectedDateTime: _currentDate2,
                            targetDateTime: _targetDateTime,
                            customGridViewPhysics:
                                const NeverScrollableScrollPhysics(),
                            markedDateCustomShapeBorder: const CircleBorder(
                                side: BorderSide(color: Colors.yellow)),
                            markedDateCustomTextStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                            showHeader: false,
                            todayTextStyle: const TextStyle(
                              color: Colors.blue,
                            ),
                            // markedDateShowIcon: true,
                            // markedDateIconMaxShown: 2,
                            // markedDateIconBuilder: (event) {
                            //   return event.icon;
                            // },
                            // markedDateMoreShowTotal:
                            //     true,
                            todayButtonColor: Colors.yellow,
                            selectedDayTextStyle: const TextStyle(
                              color: Colors.yellow,
                            ),
                            minSelectedDate: _currentDate
                                .subtract(const Duration(days: 360)),
                            maxSelectedDate:
                                _currentDate.add(const Duration(days: 360)),
                            prevDaysTextStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.pinkAccent,
                            ),
                            inactiveDaysTextStyle: const TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 16,
                            ),
                            onCalendarChanged: (DateTime date) {
                              setState(() {
                                _targetDateTime = date;
                                _currentMonth =
                                    DateFormat.yMMM().format(_targetDateTime);
                              });
                            },
                            onDayLongPressed: (DateTime date) {
                              print('long pressed date $date');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ), //
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 91, 110, 219),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 91, 110, 219),
            title: const Text("Generate PDF Report?",
                style: TextStyle(color: Colors.white)),
            content: SizedBox(
              height: 280,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("If yes, kindly note with signature",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  SfSignaturePad(
                    backgroundColor: Colors.white,
                    key: keySignaturePad,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                onPressed: generatePDF,
                child: const Text("Proceed",
                    style: TextStyle(color: Color.fromARGB(255, 0, 255, 8))),
              ),
            ],
          ),
        ),
        label: Text("Generate Report",
            style: GoogleFonts.aBeeZee(textStyle: bodyFontW)),
        icon: const Icon(Icons.picture_as_pdf),
      ),
    );
  }

  Future generatePDF() async {
    Navigator.of(context).pop();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    final image = await keySignaturePad.currentState?.toImage();

    final imageSignature = await image!.toByteData(format: ImageByteFormat.png);

    final specSched =
        FirebaseFirestore.instance.collection('users').doc(widget.docName);

    var querySnapshot = await specSched.get();

    Map<String, dynamic>? data = querySnapshot.data();

    UserProfile user = UserProfile(
        firstName: data!['firstName'].toString().trim(),
        lastName: data['lastName'].toString().trim(),
        age: data['age'],
        gender: data['gender'].toString().trim(),
        email: data['email'].toString().trim());

    final file =
        await PdfApi.generatePDF(user: user, imageSignature: imageSignature!);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    await OpenFile.open(file.path);
  }
}
