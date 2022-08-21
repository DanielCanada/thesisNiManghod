import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);
  static Color bgColor = const Color.fromARGB(255, 37, 233, 233);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: bgColor,
      body: Center(child: Lottie.asset("assets/something_wrong.json")),
    );
  }
}
