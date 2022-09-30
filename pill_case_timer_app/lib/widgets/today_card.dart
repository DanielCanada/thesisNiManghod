import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class TodayCard extends StatelessWidget {
  final String label;
  final String details;
  final DateTime alarmTime;
  const TodayCard(
      {Key? key,
      required this.label,
      required this.alarmTime,
      required this.details})
      : super(key: key);

  final subFont = const TextStyle(fontSize: 14, color: Colors.black87);
  final titleFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: const Color.fromARGB(255, 37, 233, 233),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
                child: Lottie.asset('assets/med_logo.json'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      label,
                      style: GoogleFonts.aBeeZee(
                        textStyle: titleFont,
                      ),
                    ),
                  ),
                  Text(
                    details,
                    style: GoogleFonts.aBeeZee(
                      textStyle: subFont,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        alarmTime.hour > 12
                            ? '${(alarmTime.hour - 12).toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}'
                            : alarmTime.hour == 00
                                ? '12:${alarmTime.minute.toString().padLeft(2, '0')}'
                                : '${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}',
                        style: GoogleFonts.aBeeZee(
                          textStyle: subFont,
                        ),
                      ),
                      Text(
                        alarmTime.hour > 11 ? 'PM' : 'AM',
                        style: GoogleFonts.aBeeZee(textStyle: subFont),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
