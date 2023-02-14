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
      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black);

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
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 22.0, bottom: 16),
              child: Lottie.asset('assets/med_logo.json'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    label,
                    style: GoogleFonts.aBeeZee(
                      textStyle: titleFont,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Iconsax.clipboard_text,
                        color: Colors.black, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      containerNum,
                      style: GoogleFonts.aBeeZee(
                        textStyle: subFont,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Iconsax.clock, color: Colors.black, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat.jm().format(alarmTime),
                      style: GoogleFonts.aBeeZee(textStyle: subFont),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 40),
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // checkbox
                  MSHCheckbox(
                      value: isChecked,
                      colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                        checkedColor: Color.fromARGB(255, 5, 167, 11),
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
            ),
          ],
        ));
  }
}
