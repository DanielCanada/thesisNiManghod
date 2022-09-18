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
          color: Colors.blue[300],
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: FlutterLogo(size: 72),
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
