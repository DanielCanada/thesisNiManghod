import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  String id;
  final String schedName;
  final String schedDate;
  final String details;
  final String duration;
  final String doctorName;
  final DateTime alarmTime;
  final DateTime createdAt;

  Schedule(
      {this.id = '',
      required this.schedName,
      required this.schedDate,
      required this.details,
      required this.duration,
      required this.doctorName,
      required this.alarmTime,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'schedName': schedName,
        'schedDate': schedDate,
        'details': details,
        'duration': duration,
        'doctorName': doctorName,
        'alarmTime': alarmTime,
        'createdAt': createdAt
      };

  static Schedule fromJson(Map<String, dynamic> json) => Schedule(
      id: json['id'],
      schedName: json['schedName'],
      schedDate: json['schedDate'],
      details: json['details'],
      duration: json['duration'],
      doctorName: json['doctorName'],
      alarmTime: (json['alarmTime'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate());
}
