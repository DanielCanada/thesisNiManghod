import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);
  final titleFont = const TextStyle(fontSize: 62, fontWeight: FontWeight.bold);
  final subtitleFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 233, 233),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Pill Case Timer',
            style: GoogleFonts.fjallaOne(
              textStyle: titleFont,
            ),
          ),
          Text(
            'Your Personalized Medicine Tracker',
            style: GoogleFonts.shadowsIntoLight(
              textStyle: subtitleFont,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: Lottie.asset("assets/med_app.json")),
          ),
        ],
      ),
    );
  }
}
