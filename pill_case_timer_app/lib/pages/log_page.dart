import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LogPage> {
  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final titleFont = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);

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
          "Log",
          style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SafeArea(
        child: Center(
          child: Text("Log Page"),
        ),
      ),
    );
  }
}
