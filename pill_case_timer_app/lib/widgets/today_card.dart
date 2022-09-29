import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class TodayCard extends StatelessWidget {
  TodayCard({Key? key}) : super(key: key);

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
                      "Event Name / Medicine",
                      style: GoogleFonts.aBeeZee(
                        textStyle: titleFont,
                      ),
                    ),
                  ),
                  Text(
                    "Purpose",
                    style: GoogleFonts.aBeeZee(
                      textStyle: subFont,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Time",
                    style: GoogleFonts.aBeeZee(
                      textStyle: subFont,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
