import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/pages/add_schedule.dart';
import 'package:pill_case_timer_app/pages/aux_pages/went_wrong_page.dart';
import 'package:pill_case_timer_app/pages/edit_schedule.dart';
import 'package:pill_case_timer_app/widgets/schedule_card.dart';

class SchedulePage extends StatefulWidget {
  final String name;
  const SchedulePage({Key? key, required this.name}) : super(key: key);

  @override
  State<SchedulePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SchedulePage> {
  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final titleFont = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);

  final bodyFont = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  // List of schedules
  final List<Schedule> snapshot = [];

  @override
  void initState() {
    super.initState();
  }

  Stream<List<Schedule>> getSchedules() => FirebaseFirestore.instance
      .collection('patients')
      .doc(widget.name)
      .collection("schedules")
      .orderBy("alarmTime", descending: false)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Schedule.fromJson(doc.data())).toList());

  Widget buildSchedules(Schedule sched) => Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            final docSched = FirebaseFirestore.instance
                .collection('patients')
                .doc(widget.name)
                .collection("schedules")
                .doc(sched.id);
            docSched.delete();
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Schedule deleted'),
            backgroundColor: Colors.red,
          ));
        },
        background: Padding(
          padding:
              const EdgeInsets.only(left: 10.0, right: 10.0, top: 4, bottom: 4),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => EditSchedulePage(
                        name: widget.name,
                        schedId: sched.id,
                      )));
            });
          },
          child: ScheduleCard(
              label: sched.schedName,
              schedDate: sched.schedDate,
              alarmTime: sched.alarmTime),
        ),
      );

  Widget noSchedulesRecorded() => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              Lottie.asset("assets/pills01.json", height: 180, width: 200),
              Text(
                "You have no scheduled medications!",
                style: GoogleFonts.amaticSc(textStyle: titleFont),
              ),
              SizedBox(
                height: 50,
                width: 150,
                child: TextButton(
                  onPressed: (() {
                    setState(() {
                      Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => AddSchedulePage(
                                name: widget.name,
                              )));
                    });
                  }),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Poke me to add!",
                        style: GoogleFonts.amaticSc(textStyle: bodyFont),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

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
            "Schedules",
            style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: StreamBuilder<List<Schedule>>(
            stream: getSchedules(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SomethingWentWrong();
              } else if (snapshot.hasData) {
                final schedules = snapshot.data!;
                if (schedules.isEmpty) {
                  return noSchedulesRecorded();
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: snapshot.data!.length > 6
                            ? 348
                            : (snapshot.data!.length * 58).toDouble(),
                        width: double.infinity,
                        child: ListView(
                            children: schedules.map(buildSchedules).toList()),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: (() {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AddSchedulePage(
                                      name: widget.name,
                                    )));
                          });
                        }),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.note_add,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Add",
                              style: GoogleFonts.amaticSc(textStyle: titleFont),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return Center(child: Lottie.asset("assets/loading02.json"));
              }
            },
          ),
        )));
  }
}
