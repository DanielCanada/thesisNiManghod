import 'package:flutter/material.dart';

class Schedule {
  final String schedName;
  final String schedDate;
  final DateTime alarmTime;

  const Schedule({
    required this.schedName,
    required this.schedDate,
    required this.alarmTime,
  });

  Map<String, dynamic> toJson() =>
      {'schedName': schedName, 'schedDate': schedDate, 'alarmTime': alarmTime};
}
