import 'package:flutter/material.dart';

class UserProfile {
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String email;

  UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.age,
      required this.gender,
      required this.email});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'email': email,
      };

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email']);
}
