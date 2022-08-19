import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);
  final titleFont = const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  final titleFont2 = const TextStyle(fontSize: 36, fontWeight: FontWeight.bold);
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
          Column(
            children: [
              Text(
                'A tracker that delivers',
                style: GoogleFonts.fjallaOne(
                  textStyle: titleFont,
                ),
              ),
              Text(
                'reports to your doctor',
                style: GoogleFonts.fjallaOne(
                  textStyle: titleFont,
                ),
              ),
            ],
          ),
          Text(
            'Now Let\'s Get Started !',
            style: GoogleFonts.shadowsIntoLight(
              textStyle: subtitleFont,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45.0, right: 45),
            child: Center(child: Lottie.asset("assets/doctor_01.json")),
          ),
        ],
      ),
    );
  }
}
