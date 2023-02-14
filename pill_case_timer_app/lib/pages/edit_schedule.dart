import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:day_picker/day_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/pages/aux_pages/went_wrong_page.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class EditSchedulePage extends StatefulWidget {
  final String name;
  final String schedId;

  const EditSchedulePage({Key? key, required this.name, required this.schedId})
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
  final bodyFont = const TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

  // text controllers
  late TextEditingController schedNameController;
  // late TextEditingController cNumController;
  late TextEditingController durationController;
  late TextEditingController doctorController;

  // alarm switch
  bool isSwitched = false;

  bool dateSaved = false;
  bool timeChanged = false;

  // time
  static TimeOfDay time = const TimeOfDay(hour: 00, minute: 00);
  static TimeOfDay updatedTime = const TimeOfDay(hour: 00, minute: 00);

  // background color variable
  static Color bgColor = const Color.fromARGB(255, 37, 233, 233);

  // time
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // containers
  final List<String> containerNumbers = [
    '1',
    '2',
    '3',
  ];
  String? selectedContainer;
  String? oldContainerNum;
  bool updatedContainer = false;

  // create to firebase
  Future updateSchedule(String schedName, String schedDate, String containerNum,
      String duration, String doctorName, TimeOfDay alarmTime) async {
    final docSched = FirebaseFirestore.instance
        .collection("patients")
        .doc(widget.name)
        .collection("schedules")
        .doc(widget.schedId);

    final newSched = Schedule(
        id: widget.schedId,
        schedName: schedName,
        schedDate: schedDate,
        containerNum: containerNum,
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
        .doc(widget.schedId);

    final snapshot = await specSched.get();

    if (snapshot.exists) {
      return Schedule.fromJson(snapshot.data()!);
    }
  }

  // Date Picker
  late List<String> daysSelected = [];

  late List<String> newDaysSelected = [];

  late List<String> oldDaysSelected = []; // remaining: friday_saturday

  bool isScheduled(String day) {
    var stringDaysSelected = daysSelected.join("");
    if (stringDaysSelected.contains(day)) {
      return true;
    }
    return false;
  }

  late final List<DayInWeek> _days = [
    DayInWeek("Monday", isSelected: isScheduled("Monday") ? true : false),
    DayInWeek("Tuesday", isSelected: isScheduled("Tuesday") ? true : false),
    DayInWeek("Wednesday", isSelected: isScheduled("Wednesday") ? true : false),
    DayInWeek("Thursday", isSelected: isScheduled("Thursday") ? true : false),
    DayInWeek("Friday", isSelected: isScheduled("Friday") ? true : false),
    DayInWeek("Saturday", isSelected: isScheduled("Saturday") ? true : false),
    DayInWeek("Sunday", isSelected: isScheduled("Sunday") ? true : false),
  ];

  void getDays(String schedDates) {
    if (!dateSaved) {
      for (int i = 0; i < schedDates.length; i++) {
        daysSelected.add(schedDates[i]);
      }
      oldDaysSelected = daysSelected;
      dateSaved = !dateSaved; // save old scheduled dates
    } else {}
  }

  // W I D G E T S
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
                  newDaysSelected.isEmpty
                      ? oldDaysSelected.join("")
                      : newDaysSelected.join(""),
                  updatedContainer
                      ? selectedContainer!.trim()
                      : oldContainerNum!.trim(),
                  durationController.text.trim(),
                  doctorController.text.trim(),
                  updatedTime);
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
          oldContainerNum!,
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
      updatedTime = time;
      timeChanged = true;
    });
  }

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
                  !timeChanged
                      ? time.hour > 12
                          ? '${(time.hour - 12).toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                          : time.hour == 00
                              ? '12:${time.minute.toString().padLeft(2, '0')}'
                              : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                      : updatedTime.hour > 12
                          ? '${(updatedTime.hour - 12).toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')}'
                          : updatedTime.hour == 00
                              ? '12:${time.minute.toString().padLeft(2, '0')}'
                              : '${updatedTime.hour.toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')}',
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

  Widget buildSched(Schedule? sched) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Name:
          Row(
            children: <Widget>[
              buildText("Name:", GoogleFonts.amaticSc(textStyle: titleFont)),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: 260,
                  child: TextFormField(
                    controller: schedNameController = TextEditingController(
                        text: sched!.schedName.toString()),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintStyle: const TextStyle(color: Colors.black),
                      // labelText: 'Name of product / expenses',
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: schedNameController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () => schedNameController.clear(),
                            ),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
          // Details

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(
                    "Container:", GoogleFonts.amaticSc(textStyle: titleFont)),
                SizedBox(width: 250, child: dropDownContainerNum()),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10.0),
          //   child: SizedBox(
          //     width: 260,
          //     child: TextFormField(
          //       controller: cNumController = TextEditingController(
          //           text: sched.containerNum.toString()),
          //       cursorColor: Colors.black,
          //       decoration: InputDecoration(
          //         border: const UnderlineInputBorder(),
          //         hintStyle: const TextStyle(color: Colors.black),
          //         labelStyle: const TextStyle(color: Colors.black),
          //         suffixIcon: cNumController.text.isEmpty
          //             ? Container(
          //                 width: 0,
          //               )
          //             : IconButton(
          //                 icon: const Icon(
          //                   Icons.close,
          //                   color: Colors.black,
          //                 ),
          //                 onPressed: () => cNumController.clear(),
          //               ),
          //       ),
          //       keyboardType: TextInputType.name,
          //       textInputAction: TextInputAction.done,
          //       style: const TextStyle(color: Colors.black, fontSize: 20),
          //     ),
          //   ),
          // ),
          //Duration
          Row(
            children: <Widget>[
              buildText(
                  "Duration:", GoogleFonts.amaticSc(textStyle: titleFont)),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: 260,
                  child: TextFormField(
                    controller: durationController =
                        TextEditingController(text: sched.duration.toString()),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: durationController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () => durationController.clear(),
                            ),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              )
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
          timePicker(),
          // Alarm toggler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText("Alarm", GoogleFonts.amaticSc(textStyle: titleFont)),
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
          buildText("Note: ", GoogleFonts.amaticSc(textStyle: titleFont)),
          //Day Scheduler
          Row(
            children: <Widget>[
              buildText("Doctor: ", GoogleFonts.amaticSc(textStyle: titleFont)),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: 260,
                  child: TextFormField(
                    controller: doctorController = TextEditingController(
                        text: sched.doctorName.toString()),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: doctorController.text.isEmpty
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () => doctorController.clear(),
                            ),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              )
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
      );

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
                  debugPrint("recorded Days:$daysSelected");

                  oldContainerNum = scheduleData.containerNum;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: buildSched(scheduleData),
                  );
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
