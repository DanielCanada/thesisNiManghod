import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Schedule {
  final String schedName;
  final String schedDate;
  final String details;
  final String duration;
  final String doctorName;
  final DateTime alarmTime;
  final DateTime createdAt;

  const Schedule(
      {required this.schedName,
      required this.schedDate,
      required this.details,
      required this.duration,
      required this.doctorName,
      required this.alarmTime,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'schedName': schedName,
        'schedDate': schedDate,
        'details': details,
        'duration': duration,
        'doctorName': doctorName,
        'alarmTime': alarmTime,
        'createdAt': createdAt
      };

  static Schedule fromJson(Map<String, dynamic> json) => Schedule(
      schedName: json['schedName'],
      schedDate: json['schedDate'],
      details: json['details'],
      duration: json['duration'],
      doctorName: json['doctorName'],
      alarmTime: (json['alarmTime'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate());
}
