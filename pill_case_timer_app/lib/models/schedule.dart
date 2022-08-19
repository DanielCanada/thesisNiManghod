import 'package:flutter/material.dart';

class Schedule {
  final String label;
  final String schedDate;
  final TimeOfDay alarmTime;

  const Schedule({
    required this.label,
    required this.schedDate,
    required this.alarmTime,
  });
}
