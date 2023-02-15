import 'package:flutter/material.dart';

// fonts
const pageTitleFont =
    TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);
const pageTitleFontWhite =
    TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);
const titleFont =
    TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black);
const titleFontWhite =
    TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white);
const titleFontBlurred =
    TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black38);
const bodyFont =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
const bodyFontW =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);

Widget currentMonthWidget(String currentMonth) {
  return Expanded(
      child: Text(
    currentMonth,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
    ),
  ));
}
