import 'package:flutter/material.dart';

class Schedule {
  final String label;
  final String schedDate;
  final String alarmTime;

  const Schedule({
    required this.label,
    required this.schedDate,
    required this.alarmTime,
  });
}
