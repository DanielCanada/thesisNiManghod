import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

class TodayCard extends StatelessWidget {
  final String label;
  final String containerNum;
  final DateTime alarmTime;
  final bool isChecked;
  void Function(bool) onChanged;
  TodayCard({
    Key? key,
    required this.label,
    required this.alarmTime,
    required this.containerNum,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  final subFont = const TextStyle(fontSize: 14, color: Colors.black87);
  final titleFont = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  final markedAsDone = LinearGradient(
    colors: [
      Colors.greenAccent.withOpacity(0.40),
      Colors.greenAccent.withOpacity(0.60),
      Colors.greenAccent.withOpacity(0.65),
      Colors.greenAccent.withOpacity(0.60),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  final markedAsNotDone = LinearGradient(
    colors: [
      Colors.redAccent.withOpacity(0.40),
      Colors.redAccent.withOpacity(0.60),
      Colors.redAccent.withOpacity(0.45),
      Colors.redAccent.withOpacity(0.60),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  Widget buildMedicineIcon(String container) {
    Widget? lottie;
    switch (container) {
      case "1":
        {
          // statements;

          lottie = Lottie.asset(
            'assets/tablet_02.json',
          );
        }
        break;

      case "2":
        {
          //statements;
          lottie = Lottie.asset('assets/med_bottle_01.json');
        }
        break;

      case "3":
        {
          //statements;
          lottie = Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Lottie.asset('assets/tablet_01.json', height: 50, width: 50),
          );
        }
        break;
    }
    ;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: lottie,
    );
  }

  Widget buildMiddlePart() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.aBeeZee(
              textStyle: titleFont,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.box, color: Colors.black, size: 20),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    containerNum,
                    style: GoogleFonts.aBeeZee(
                      textStyle: subFont,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Iconsax.clock, color: Colors.black, size: 20),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    DateFormat.jm().format(alarmTime),
                    style: GoogleFonts.aBeeZee(textStyle: subFont),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButtonAndTimeAgo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // checkbox
          MSHCheckbox(
              value: isChecked,
              colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                checkedColor: const Color.fromARGB(255, 5, 167, 11),
                uncheckedColor: Colors.grey.shade400,
              ),
              style: MSHCheckboxStyle.fillScaleColor,
              onChanged: onChanged),

          // time ago
          Text(
            Jiffy()
                .startOf(Units.DAY)
                .add(hours: alarmTime.hour, minutes: alarmTime.minute)
                .fromNow(),
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer.clearGlass(
      height: 112,
      width: MediaQuery.of(context).size.width,
      gradient: isChecked ? markedAsDone : markedAsNotDone,
      borderGradient: LinearGradient(
        colors: [
          Colors.blue.withOpacity(0.60),
          Colors.blue.withOpacity(0.30),
          Colors.blue.withOpacity(0.30),
          Colors.blue.withOpacity(0.60),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.39, 0.40, 1.0],
      ),
      blur: 20,
      borderRadius: BorderRadius.circular(20.0),
      borderWidth: 2.0,
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.20),
      child: Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildMedicineIcon(containerNum),
            buildMiddlePart(),
            buildButtonAndTimeAgo(),
          ],
        ),
      ),
    );
  }
}
