import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:day_picker/day_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/pages/aux_pages/went_wrong_page.dart';

class EditSchedulePage extends StatefulWidget {
  final String name;
  final String schedName;

  const EditSchedulePage(
      {Key? key, required this.name, required this.schedName})
      : super(key: key);

  @override
  State<EditSchedulePage> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<EditSchedulePage> {
  // textstyles
  final pageTitleFont = const TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);
  final titleFont = const TextStyle(
      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);
  final buttonFont = const TextStyle(
      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black);

  // text controllers
  late TextEditingController schedNameController;
  late TextEditingController detailsController;
  late TextEditingController durationController;
  late TextEditingController doctorController;

  // alarm switch
  bool isSwitched = false;

  // time
  static TimeOfDay time = const TimeOfDay(hour: 00, minute: 00);

  // background color variable
  static Color bgColor = const Color.fromARGB(255, 37, 233, 233);

  // time
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // create to firebase
  Future updateSchedule(String schedName, String schedDate, String details,
      String duration, String doctorName, TimeOfDay alarmTime) async {
    final docSched = FirebaseFirestore.instance
        .collection("patients")
        .doc(widget.name)
        .collection("schedules")
        .doc(widget.schedName);

    final newSched = Schedule(
        schedName: schedName,
        schedDate: schedDate,
        details: details,
        duration: duration,
        doctorName: doctorName,
        alarmTime: join(DateTime.now(), alarmTime),
        createdAt: DateTime.now());

    final json = newSched.toJson();

    await docSched.update(json);
  }

  // get user
  Future<Schedule?> getSched() async {
    final specSched = FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.name)
        .collection('schedules')
        .doc(widget.schedName);

    final snapshot = await specSched.get();

    if (snapshot.exists) {
      return Schedule.fromJson(snapshot.data()!);
    }
  }

  // Date Picker
  late List<String> daysSelected = [];

  late List<String> newDaysSelected = [];

  bool isScheduled(String day) {
    if (daysSelected.contains(day)) {
      return true;
    } else {
      return false;
    }
  }

  late final List<DayInWeek> _days = [
    DayInWeek("M", isSelected: isScheduled("M") ? true : false),
    DayInWeek("T", isSelected: isScheduled("T") ? true : false),
    DayInWeek("W", isSelected: isScheduled("W") ? true : false),
    DayInWeek("Th", isSelected: isScheduled("Th") ? true : false),
    DayInWeek("F", isSelected: isScheduled("F") ? true : false),
    DayInWeek("Sa", isSelected: isScheduled("Sa") ? true : false),
    DayInWeek("Su", isSelected: isScheduled("Su") ? true : false),
  ];

  void getDays(String schedDates) {
    for (int i = 0; i < schedDates.length; i++) {
      daysSelected.add(schedDates[i]);
    }
  }

  // W I D G E T S
  //name widget
  Widget buildName(TextEditingController controller, String existing) =>
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: SizedBox(
          width: 260,
          child: TextFormField(
            controller: controller = TextEditingController(text: existing),
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
              updateSchedule(
                  schedNameController.text.trim(),
                  newDaysSelected.join(""),
                  detailsController.text.trim(),
                  durationController.text.trim(),
                  doctorController.text.trim(),
                  time);
              daysSelected.clear();
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

  Widget buildSched(Schedule? sched) => Container(
        padding: const EdgeInsets.only(left: 30, right: 30.0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Name:
            Row(
              children: <Widget>[
                buildText("Name:", GoogleFonts.amaticSc(textStyle: titleFont)),
                buildName(schedNameController, sched!.schedName.toString()),
              ],
            ),
            // Details
            Row(
              children: <Widget>[
                buildText(
                    "Details:", GoogleFonts.amaticSc(textStyle: titleFont)),
                buildName(detailsController, sched.details.toString()),
              ],
            ),
            //Duration
            Row(
              children: <Widget>[
                buildText(
                    "Duration:", GoogleFonts.amaticSc(textStyle: titleFont)),
                buildName(durationController, sched.duration.toString()),
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
                    if (values == daysSelected.contains(values)) {
                      newDaysSelected.remove(values);
                      daysSelected.remove(values);
                    } else {
                      newDaysSelected = values;
                    }
                    print(newDaysSelected);
                  },
                ),
              ),
            ),
            //Time Start
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildText("Start:", GoogleFonts.amaticSc(textStyle: titleFont)),
                TextButton(
                  onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                        context: context, initialTime: time);

                    // cancel = do nothing
                    if (newTime == null) return;
                    // ok = save
                    setState(() => newTime = time);
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
                buildText("Alarm", GoogleFonts.amaticSc(textStyle: titleFont)),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      print(isSwitched);
                    });
                  },
                  activeTrackColor: const Color.fromARGB(255, 132, 145, 218),
                  activeColor: const Color.fromARGB(255, 0, 255, 8),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Sound
            buildText("Sound:", GoogleFonts.amaticSc(textStyle: titleFont)),
            //Day Scheduler
            Row(
              children: <Widget>[
                buildText(
                    "Doctor: ", GoogleFonts.amaticSc(textStyle: titleFont)),
                buildName(doctorController, sched.doctorName.toString()),
              ],
            ),
            const SizedBox(height: 24),
            // Save Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton("update"),
              ],
            )
          ],
        ),
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
        title:
            buildText("Edit", GoogleFonts.amaticSc(textStyle: pageTitleFont)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: FutureBuilder<Schedule?>(
              future: getSched(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SomethingWentWrong();
                } else if (snapshot.hasData) {
                  final scheduleData = snapshot.data;
                  TimeOfDay recordTime =
                      TimeOfDay.fromDateTime(scheduleData!.alarmTime);

                  time = recordTime;
                  getDays(scheduleData.schedDate);
                  print(daysSelected);
                  return buildSched(scheduleData);
                } else {
                  return Center(
                    child: Lottie.asset("assets/loading02.json"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
