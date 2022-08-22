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
  final DateTime alarmTime;

  final titleFont = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);

  final titleFont2 = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

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
              style: GoogleFonts.amaticSc(textStyle: titleFont2),
            ),
            Row(
              children: [
                Text(
                  alarmTime.hour > 12
                      ? '${(alarmTime.hour - 12).toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}'
                      : alarmTime.hour == 00
                          ? '12:${alarmTime.minute.toString().padLeft(2, '0')}'
                          : '${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.amaticSc(textStyle: titleFont),
                ),
                Text(
                  alarmTime.hour > 12 ? 'pm' : 'am',
                  style: GoogleFonts.amaticSc(textStyle: titleFont),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
