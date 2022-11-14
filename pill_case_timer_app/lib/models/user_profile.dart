class UserProfile {
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String email;
  bool deviceActivated;

  UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.age,
      required this.gender,
      required this.email,
      this.deviceActivated = false});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'email': email,
        'deviceActivated': deviceActivated,
      };

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      deviceActivated: json['deviceActivated']);
}
