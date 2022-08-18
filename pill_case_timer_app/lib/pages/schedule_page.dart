import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SchedulePage> {
  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  final titleFont = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);

  final bodyFont = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);

  // List of schedules

  final List<String> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          "Schedule",
          style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: items.isEmpty
                ? Center(
                    child: SizedBox(
                      height: 70,
                      width: 90,
                      child: TextButton(
                        onPressed: (() {
                          setState(() {
                            items.add("New Schedule");
                          });
                        }),
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle_outline_outlined),
                            const SizedBox(width: 8),
                            Text(
                              "Add",
                              style: GoogleFonts.amaticSc(textStyle: titleFont),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: items.length > 6
                            ? 330
                            : (items.length * 55).toDouble(),
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                items[index],
                                style:
                                    GoogleFonts.amaticSc(textStyle: bodyFont),
                              ),
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: (() {
                          setState(() {
                            items.add("New Schedule");
                          });
                        }),
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle_outline_outlined),
                            const SizedBox(width: 8),
                            Text(
                              "Add",
                              style: GoogleFonts.amaticSc(textStyle: titleFont),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
