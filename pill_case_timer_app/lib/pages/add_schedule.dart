import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:day_picker/day_picker.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  final bodyFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  // text controllers
  final schedNameController = TextEditingController();
  // final cNumController = TextEditingController();
  final durationController = TextEditingController();
  final doctorController = TextEditingController();

  // alarm switch
  bool isSwitched = false;

  // background color variable
  static Color bgColor = const Color.fromARGB(255, 37, 233, 233);

  // Time Picker
  TimeOfDay time = const TimeOfDay(hour: 12, minute: 00);
  bool iosStyle = true;

  // Container Numbers
  // gender & age
  final List<String> containerNumbers = [
    '1',
    '2',
    '3',
  ];
  String? selectedContainer;
  bool updatedContainer = false;

  @override
  void initState() {
    super.initState();
    schedNameController.addListener(() => setState(() {}));
    // cNumController.addListener(() => setState(() {}));
    durationController.addListener(() => setState(() {}));
    doctorController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    schedNameController.dispose();
    // cNumController.dispose();
    durationController.dispose();
    doctorController.dispose();
    super.dispose();
  }

  // time
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // create to firebase
  Future createSchedule(String schedName, String schedDate, String containerNum,
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
        containerNum: containerNum,
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
        padding: const EdgeInsets.only(left: 8.0),
        child: SizedBox(
          width: 250,
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
                    selectedContainer!.trim(),
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

  Widget dropDownContainerNum() => DropdownButtonFormField2(
        decoration: InputDecoration(
          //Add isDense true and zero Padding.
          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
          isDense: false,
          contentPadding: EdgeInsets.zero,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Colors.deepOrange,
                  width: 2,
                  style: BorderStyle.solid)),
          //Add more decoration as you want here
          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
        ),
        isExpanded: true,
        hint: Text(
          "Select Container",
          style: GoogleFonts.amaticSc(
            textStyle: bodyFont,
          ),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.deepOrange,
        ),
        iconSize: 30,
        buttonHeight: 50,
        buttonPadding: const EdgeInsets.only(left: 20, right: 10),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: containerNumbers
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.amaticSc(
                      textStyle: bodyFont,
                    ),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select containers.';
          }
        },
        onChanged: (value) {
          //Do something when changing the item if you want.
          selectedContainer = value.toString();
          updatedContainer = true;
        },
        onSaved: (value) {
          selectedContainer = value.toString();
          updatedContainer = true;
        },
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("Container:",
                            GoogleFonts.amaticSc(textStyle: titleFont)),
                        SizedBox(width: 250, child: dropDownContainerNum()),
                      ],
                    ),
                  ),

                  // buildName(cNumController),
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
                  // Sound / Notes
                  buildText(
                      "Note: ", GoogleFonts.amaticSc(textStyle: titleFont)),
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
