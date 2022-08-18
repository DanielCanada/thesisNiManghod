import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {Key? key,
      required this.label,
      required this.schedDate,
      required this.alarmTime})
      : super(key: key);
  final String label;
  final String schedDate;
  final String alarmTime;

  final titleFont = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);

  final bodyFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 37, 233, 233),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24.0, right: 24.0, top: 5, bottom: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              label,
              style: GoogleFonts.amaticSc(textStyle: titleFont),
            ),
            Text(
              schedDate,
              style: GoogleFonts.amaticSc(textStyle: titleFont),
            ),
            Text(
              alarmTime,
              style: GoogleFonts.amaticSc(textStyle: titleFont),
            ),
          ]),
        ),
      ),
    );
  }
}
