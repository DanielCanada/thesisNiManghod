import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_case_timer_app/pages/aux_pages/second_screen.dart';
import 'package:pill_case_timer_app/pages/calendar/api/notifications_api.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AboutPage> {
  // local notif

  @override
  void initState() {}

  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final titleFont = const TextStyle(
      fontSize: 46, fontWeight: FontWeight.bold, color: Colors.black);

  final bodyFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 233, 233),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Team THESIS",
          style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "MEET THE TEAM!",
                  style: GoogleFonts.amaticSc(textStyle: titleFont),
                ),
              ),
              const SizedBox(height: 16),
              // Text(
              //   "App built using Flutter with google fonts, db_name, and a little bit of Google :D",
              //   style: GoogleFonts.amaticSc(textStyle: bodyFont),
              // ),
              const SizedBox(height: 16),
              Text(
                "Members: ",
                style: GoogleFonts.amaticSc(textStyle: bodyFont),
              ),
              // add widgets for members
            ],
          ),
        ),
      ),
    );
  }
}
