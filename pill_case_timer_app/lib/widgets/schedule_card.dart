import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatelessWidget {
  ScheduleCard(
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

  final subTitleFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  String _schedDates = "";

  void getSchedDates() {
    for (var i = 0; i < schedDate.length; i++) {
      if (schedDate[i].contains("M")) {
        _schedDates += "M";
      } else if (schedDate[i].contains("T")) {
        if (schedDate[i + 1].contains("h")) {
          _schedDates += "Th";
        } else if (schedDate[i + 1].contains("u")) {
          _schedDates += "T";
        }
      } else if (schedDate[i].contains("W")) {
        _schedDates += "W";
      } else if (schedDate[i].contains("F")) {
        _schedDates += "F";
      } else if (schedDate[i].contains("S")) {
        if (schedDate[i + 1].contains("a")) {
          _schedDates += "Sa";
        } else if (schedDate[i + 1].contains("u")) {
          _schedDates += "Su";
        }
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    getSchedDates();
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
              _schedDates,
              style: GoogleFonts.amaticSc(textStyle: titleFont2),
            ),
            Text(
              DateFormat.jm().format(alarmTime),
              style: GoogleFonts.amaticSc(textStyle: titleFont),
            ),
          ]),
        ),
      ),
    );
  }
}
