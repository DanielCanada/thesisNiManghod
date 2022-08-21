import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class UnderDevelopment extends StatelessWidget {
  const UnderDevelopment({Key? key}) : super(key: key);
  static Color bgColor = const Color.fromARGB(255, 37, 233, 233);
  final titleFont = const TextStyle(fontSize: 34, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          children: [
            Lottie.asset("assets/development.json"),
            Text(
              'Currently in development',
              style: GoogleFonts.fjallaOne(
                textStyle: titleFont,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
