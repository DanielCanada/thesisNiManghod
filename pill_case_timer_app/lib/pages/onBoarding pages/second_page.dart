import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);
  final titleFont = const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  final subtitleFont = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 132, 145, 218),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'An app',
              style: GoogleFonts.fjallaOne(
                textStyle: titleFont,
              ),
            ),
            Text(
              'for everyone',
              style: GoogleFonts.fjallaOne(
                textStyle: titleFont,
              ),
            ),
            Text(
              'especially those who forget...',
              style: GoogleFonts.shadowsIntoLight(
                textStyle: subtitleFont,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(child: Lottie.asset("assets/schedule.json")),
            ),
          ],
        ),
      ),
    );
  }
}
