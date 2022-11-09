import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:pill_case_timer_app/pages/calendar/event.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:table_calendar/table_calendar.dart';

import 'api/pdf_api.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  // signature
  final keySignaturePad = GlobalKey<SfSignaturePadState>();
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime tempDay = DateTime(2022, 08, 29).toUtc();

  // text styles
  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);
  final pageTitleFontWhite = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);
  final titleFont = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);
  final titleFontWhite = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white);
  final titleFontBlurred = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black38);
  final bodyFont = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
  final bodyFontW = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
  // TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    selectedEvents.addAll({
      tempDay: [
        Event(title: 'Today\'s Event 1'),
        Event(title: 'Today\'s Event 2'),
      ],
    });
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: (DateTime.now().hour > 12 && DateTime.now().hour < 18)
                    ? Lottie.asset('assets/background_01.json',
                        fit: BoxFit.fill)
                    : DateTime.now().hour > 18
                        ? Lottie.asset('assets/b_early_morning.json',
                            fit: BoxFit.fill)
                        : Lottie.asset('assets/b_night.json',
                            fit: BoxFit.fill)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateTime.now().hour > 12
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: Text(
                          "Logs",
                          style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20),
                        child: Text(
                          "Logs",
                          style: GoogleFonts.amaticSc(
                              textStyle: pageTitleFontWhite),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: TableCalendar(
                        focusedDay: selectedDay,
                        firstDay: DateTime(2022, 07, 01),
                        lastDay: DateTime(2050),
                        calendarFormat: format,
                        onFormatChanged: (CalendarFormat _format) {
                          setState(() {
                            format = _format;
                          });
                        },
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        daysOfWeekVisible: true,

                        //Day Changed
                        onDaySelected: (DateTime selectDay, DateTime focusDay) {
                          setState(() {
                            selectedDay = selectDay;
                            focusedDay = focusDay;
                          });
                          print(focusedDay);
                        },
                        selectedDayPredicate: (DateTime date) {
                          return isSameDay(selectedDay, date);
                        },

                        eventLoader: _getEventsfromDay,

                        //To style the Calendar
                        calendarStyle: CalendarStyle(
                          defaultTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFont),
                          todayTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFontWhite),
                          weekendTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFont),
                          holidayTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFontWhite),
                          outsideTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFontBlurred),
                          isTodayHighlighted: true,
                          selectedDecoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          selectedTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFontWhite),
                          todayDecoration: BoxDecoration(
                            color: Colors.purpleAccent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          defaultDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          weekendDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          outsideDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          leftChevronIcon: const Icon(Iconsax.arrow_left_2,
                              color: Colors.black),
                          rightChevronIcon: const Icon(Iconsax.arrow_right_3,
                              color: Colors.black),
                          titleTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFont),
                          formatButtonVisible: true,
                          titleCentered: true,
                          formatButtonShowsNext: false,
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          formatButtonTextStyle:
                              GoogleFonts.amaticSc(textStyle: titleFontWhite),
                        ),
                      ),
                    ),
                  ),
                ),
                ..._getEventsfromDay(selectedDay).map(
                  (Event event) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.blue,
                      title: Text(
                        event.title,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

    final file = await PdfApi.generatePDF(
        patientName: "Administrator",
        content: 'Lorem Ipsum',
        imageSignature: imageSignature!);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    await OpenFile.open(file.path);
  }
}
// 


// TextButton(
//                 child: const Text("Proceed"),
//                 onPressed: () {
//                   if (_eventController.text.isEmpty) {
//                   } else {
//                     if (selectedEvents[selectedDay] != null) {
//                       selectedEvents[selectedDay]?.add(
//                         Event(title: _eventController.text),
//                       );
//                       selectedEvents[tempDay]?.add(
//                         Event(title: "New Event"),
//                       );
//                     } else {
//                       selectedEvents[selectedDay] = [
//                         Event(title: _eventController.text)
//                       ];
//                       selectedEvents[tempDay] = [Event(title: "New Event")];
//                     }
//                   }
//                   Navigator.pop(context);
//                   _eventController.clear();
//                   setState(() {});
//                   return;
//                 },
//               ),