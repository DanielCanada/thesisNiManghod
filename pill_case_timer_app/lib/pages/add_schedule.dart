import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:day_picker/day_picker.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

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
  bool iosStyle = true;

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
        .doc();

    final newSched = Schedule(
        id: docSched.id,
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
      "Monday",
    ),
    DayInWeek(
      "Tuesday",
    ),
    DayInWeek(
      "Wednesday",
    ),
    DayInWeek(
      "Thursday",
    ),
    DayInWeek(
      "Friday",
    ),
    DayInWeek(
      "Saturday",
    ),
    DayInWeek(
      "Sunday",
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
              if (schedNameController.text.trim().isEmpty ||
                  doctorController.text.trim().isEmpty ||
                  durationController.text.trim().isEmpty) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Kindly fill in the required information'),
                    backgroundColor: Colors.red,
                    margin: EdgeInsets.all(20),
                    behavior: SnackBarBehavior.floating,
                  ));
                });
              } else {
                createSchedule(
                    schedNameController.text.trim(),
                    daysSelected.join(""),
                    detailsController.text.trim(),
                    durationController.text.trim(),
                    doctorController.text.trim(),
                    time);
                Navigator.pop(context);
              }
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

  Widget timePicker() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                showPicker(
                  context: context,
                  value: time,
                  onChange: onTimeChanged,
                  minuteInterval: MinuteInterval.ONE,
                  // Optional onChange to receive value as DateTime
                  onChangeDateTime: (DateTime dateTime) {
                    // print(dateTime);
                    debugPrint("[debug datetime]:  $dateTime");
                  },
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  'START:  ',
                  style: GoogleFonts.amaticSc(textStyle: titleFont),
                ),
                Text(
                  time.hour > 12
                      ? '${(time.hour - 12).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                      : time.hour == 00
                          ? '12:${time.minute.toString().padLeft(2, '0')}'
                          : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.amaticSc(textStyle: titleFont),
                ),
                Text(
                  time.hour > 11 ? 'pm' : 'am',
                  style: GoogleFonts.amaticSc(textStyle: titleFont),
                ),
              ],
            ),
          ),
        ],
      );

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      time = newTime;
    });
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
                      buildText("Purpose:",
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
                  timePicker(),
                  // Alarm toggler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildText(
                          "Alarm", GoogleFonts.amaticSc(textStyle: titleFont)),
                      CupertinoSwitch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        trackColor: const Color.fromARGB(255, 132, 145, 218),
                        activeColor: const Color.fromARGB(255, 0, 255, 8),
                      ),
                    ],
                  ),
                  // Sound
                  buildText(
                      "Sound", GoogleFonts.amaticSc(textStyle: titleFont)),
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
