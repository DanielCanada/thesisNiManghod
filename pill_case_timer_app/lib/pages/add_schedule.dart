import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:day_picker/day_picker.dart';
import 'package:pill_case_timer_app/models/schedule.dart';

class AddSchedulePage extends StatefulWidget {
  final String name;

  const AddSchedulePage({Key? key, required this.name}) : super(key: key);

  @override
  State<AddSchedulePage> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedulePage> {
  // textstyles
  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);
  final titleFont = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);
  final buttonFont = const TextStyle(
      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black);

  // text controllers
  final schedNameController = TextEditingController();
  final detailsController = TextEditingController();
  final durationController = TextEditingController();
  final doctorController = TextEditingController();

  // alarm switch
  bool isSwitched = false;

  // background color variable
  static Color bgColor = const Color.fromARGB(255, 37, 233, 233);

  // Time Picker
  TimeOfDay time = const TimeOfDay(hour: 12, minute: 00);

  @override
  void initState() {
    super.initState();
    schedNameController.addListener(() => setState(() {}));
    detailsController.addListener(() => setState(() {}));
    durationController.addListener(() => setState(() {}));
    doctorController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    schedNameController.dispose();
    detailsController.dispose();
    durationController.dispose();
    doctorController.dispose();
    super.dispose();
  }

  // time
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // create to firebase
  Future createSchedule(String schedName, String schedDate, String details,
      String duration, String doctorName, TimeOfDay alarmTime) async {
    final docSched = FirebaseFirestore.instance
        .collection("patients")
        .doc(widget.name)
        .collection("schedules")
        .doc(schedName);

    final newSched = Schedule(
        schedName: schedName,
        schedDate: schedDate,
        details: details,
        duration: duration,
        doctorName: doctorName,
        alarmTime: join(DateTime.now(), alarmTime),
        createdAt: DateTime.now());

    final json = newSched.toJson();

    await docSched.set(json);
  }

  // Date Picker
  static List<String> daysSelected = [];

  final List<DayInWeek> _days = [
    DayInWeek(
      "M",
    ),
    DayInWeek(
      "T",
    ),
    DayInWeek(
      "W",
    ),
    DayInWeek(
      "Th",
    ),
    DayInWeek(
      "F",
    ),
    DayInWeek(
      "Sa",
    ),
    DayInWeek(
      "Su",
    ),
  ];

  // W I D G E T S
  //name widget
  Widget buildName(TextEditingController controller) => Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: SizedBox(
          width: 260,
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintStyle: const TextStyle(color: Colors.black),
              // labelText: 'Name of product / expenses',
              labelStyle: const TextStyle(color: Colors.black),
              suffixIcon: controller.text.isEmpty
                  ? Container(
                      width: 0,
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () => controller.clear(),
                    ),
            ),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      );

  // button widget
  Widget buildButton(String label) => SizedBox(
        height: 70,
        width: 140,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 5.0),
          child: TextButton(
            onPressed: () {
              createSchedule(
                  schedNameController.text.trim(),
                  daysSelected.join(""),
                  detailsController.text.trim(),
                  durationController.text.trim(),
                  doctorController.text.trim(),
                  time);
              Navigator.pop(context);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(6)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 132, 145, 218)),
            ),
            child: Text(
              label,
              style: GoogleFonts.amaticSc(textStyle: buttonFont),
            ),
          ),
        ),
      );

  Widget buildText(String text, TextStyle textStyle) => Text(
        text,
        style: textStyle,
      );

  // show when there is no input
  void nothingToSave() {
    const message = 'Nothing to save';
    const snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 15),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: buildText(
            "Add Schedule", GoogleFonts.amaticSc(textStyle: pageTitleFont)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Name:
                  Row(
                    children: <Widget>[
                      buildText(
                          "Name:", GoogleFonts.amaticSc(textStyle: titleFont)),
                      buildName(schedNameController),
                    ],
                  ),
                  // Details
                  Row(
                    children: <Widget>[
                      buildText("Details:",
                          GoogleFonts.amaticSc(textStyle: titleFont)),
                      buildName(detailsController),
                    ],
                  ),
                  //Duration
                  Row(
                    children: <Widget>[
                      buildText("Duration:",
                          GoogleFonts.amaticSc(textStyle: titleFont)),
                      buildName(durationController),
                    ],
                  ),
                  const SizedBox(height: 6),
                  //Day Scheduler
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SelectWeekDays(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        days: _days,
                        border: false,
                        selectedDayTextColor: Colors.black,
                        unSelectedDayTextColor: Colors.black,
                        daysFillColor: const Color.fromARGB(255, 158, 169, 236),
                        daysBorderColor: Colors.black,
                        backgroundColor: bgColor,
                        onSelect: (values) {
                          daysSelected = values;
                          // <== Callback to handle the selected days
                          print(values);
                        },
                      ),
                    ),
                  ),
                  //Time Start
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildText(
                          "Start:", GoogleFonts.amaticSc(textStyle: titleFont)),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? newTime = await showTimePicker(
                              context: context, initialTime: time);

                          // cancel = do nothing
                          if (newTime == null) return;
                          // ok = save
                          setState(() => time = newTime);
                        },
                        child: Row(
                          children: [
                            Text(
                              time.hour > 12
                                  ? '${(time.hour - 12).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                                  : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                              style: GoogleFonts.amaticSc(textStyle: titleFont),
                            ),
                            Text(
                              time.hour > 12 ? 'pm' : 'am',
                              style: GoogleFonts.amaticSc(textStyle: titleFont),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // Alarm toggler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildText(
                          "Alarm", GoogleFonts.amaticSc(textStyle: titleFont)),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        activeTrackColor:
                            const Color.fromARGB(255, 132, 145, 218),
                        activeColor: const Color.fromARGB(255, 0, 255, 8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Sound
                  buildText(
                      "Sound:", GoogleFonts.amaticSc(textStyle: titleFont)),
                  //Day Scheduler
                  Row(
                    children: <Widget>[
                      buildText("Doctor:",
                          GoogleFonts.amaticSc(textStyle: titleFont)),
                      buildName(doctorController),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Save Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton("save"),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
