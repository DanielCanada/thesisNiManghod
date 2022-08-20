import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_case_timer_app/pages/log_page.dart';
import 'package:pill_case_timer_app/pages/schedule_page.dart';
import 'package:pill_case_timer_app/pages/about.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // current user
  final user = FirebaseAuth.instance.currentUser!;
  late String userName = user.email.toString();
  late List<String> name = userName.split('@');

  // style of title
  final titleFont = const TextStyle(fontSize: 64, fontWeight: FontWeight.bold);

  final buttonFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final versionFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  // button widget - diri lang edit kung ano ang gusto niyo nga button
  Widget buildButton(String label) => SizedBox(
        height: 70,
        width: 140,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 5.0),
          child: TextButton(
            onPressed: () {
              if (label == 'Schedule') {
                debugPrint('$label Clicked');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SchedulePage(
                          name: name[0].toString(),
                        )));
              } else if (label == 'Logs') {
                debugPrint('$label Clicked');
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LogPage()));
              } else {
                debugPrint('$label Clicked');
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: const BorderSide(width: 4.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(0)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 132, 145, 218)),
            ),
            child: Text(
              label,
              style: GoogleFonts.amaticSc(
                textStyle: buttonFont,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 233, 233),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    'PILL',
                    style: GoogleFonts.amaticSc(
                      textStyle: titleFont,
                    ),
                  ),
                  Text(
                    'CASE',
                    style: GoogleFonts.amaticSc(
                      textStyle: titleFont,
                    ),
                  ),
                  Text(
                    'TIMER',
                    style: GoogleFonts.amaticSc(
                      textStyle: titleFont,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // schedule button
                  buildButton("Schedule"),
                  // Log button
                  buildButton("Logs"),
                  // Settings button
                  buildButton("About"),
                  // button decoration including image and version #
                  Container(
                    alignment: const Alignment(0, 0.80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Image(
                          image: AssetImage('assets/hello_patients_01.png'),
                          height: 180,
                          width: 180,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              "Hello There!",
                              style: GoogleFonts.amaticSc(
                                textStyle: buttonFont,
                              ),
                            ),
                            Text(
                              name[0],
                              style: GoogleFonts.amaticSc(
                                textStyle: buttonFont,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                              },
                              child: Text(
                                "Sign Out?",
                                style: GoogleFonts.amaticSc(
                                  textStyle: versionFont,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
