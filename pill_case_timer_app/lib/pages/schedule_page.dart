import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/pages/add_schedule.dart';
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
  final List<Schedule> schedList = [];

  @override
  void initState() {
    super.initState();
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
          "Schedule",
          style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: schedList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                              builder: (context) => AddSchedulePage(
                                    schedList: schedList,
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
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: schedList.length > 6
                            ? 348
                            : (schedList.length * 58).toDouble(),
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: schedList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  schedList.removeAt(index);
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Schedule deleted'),
                                  backgroundColor: Colors.red,
                                ));
                              },
                              background: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 4, bottom: 4),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 24.0),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                              ),
                              child: ScheduleCard(
                                  label: schedList[index].schedName,
                                  schedDate: schedList[index].schedDate,
                                  alarmTime: schedList[index].alarmTime),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: (() {
                          setState(() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddSchedulePage(
                                      schedList: schedList,
                                      name: widget.name,
                                    )));
                          });
                        }),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_circle_outline_outlined,
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
                  ),
                ),
              ),
            ),
    );
  }
}
