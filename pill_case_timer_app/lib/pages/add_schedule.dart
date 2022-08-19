import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:day_picker/day_picker.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/pages/schedule_page.dart';

class AddSchedulePage extends StatefulWidget {
  final List<Schedule> schedList;

  const AddSchedulePage({Key? key, required this.schedList}) : super(key: key);

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
  final nameController = TextEditingController();
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
    nameController.addListener(() => setState(() {}));
    detailsController.addListener(() => setState(() {}));
    durationController.addListener(() => setState(() {}));
    doctorController.addListener(() => setState(() {}));
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
              addSchedule();
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

  // function to save schedule
  void addSchedule() {
    if (nameController.text.isEmpty && doctorController.text.isEmpty) {
      nothingToSave();
    } else {
      final schedule = Schedule(
        label: nameController.text,
        alarmTime: time,
        schedDate: daysSelected.join(""),
      );
      widget.schedList.add(schedule);
      print(daysSelected);
      nameController.clear();
      detailsController.clear();
      durationController.clear();
      doctorController.clear();

      debugPrint('Saved');
      Navigator.of(context).pop();
    }
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
        title: Text(
          "Add Schedule",
          style: GoogleFonts.amaticSc(textStyle: pageTitleFont),
        ),
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
                      Text(
                        "Name:",
                        style: GoogleFonts.amaticSc(textStyle: titleFont),
                      ),
                      buildName(nameController),
                    ],
                  ),
                  // Details
                  Row(
                    children: <Widget>[
                      Text(
                        "Details:",
                        style: GoogleFonts.amaticSc(textStyle: titleFont),
                      ),
                      buildName(detailsController),
                    ],
                  ),
                  //Duration
                  Row(
                    children: <Widget>[
                      Text(
                        "Duration:",
                        style: GoogleFonts.amaticSc(textStyle: titleFont),
                      ),
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
                      Text(
                        "Start:",
                        style: GoogleFonts.amaticSc(textStyle: titleFont),
                      ),
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
                      Text(
                        "Alarm ",
                        style: GoogleFonts.amaticSc(textStyle: titleFont),
                      ),
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
                  Text(
                    "Sound:  ",
                    style: GoogleFonts.amaticSc(textStyle: titleFont),
                  ),
                  //Day Scheduler
                  Row(
                    children: <Widget>[
                      Text(
                        "Doctor:",
                        style: GoogleFonts.amaticSc(textStyle: titleFont),
                      ),
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
