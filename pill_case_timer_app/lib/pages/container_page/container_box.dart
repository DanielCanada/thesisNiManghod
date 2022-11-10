import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ContainerBox extends StatelessWidget {
  final String containerName;
  final String iconPath;
  final bool powerOn;
  void Function(bool)? onChanged;

  ContainerBox({
    super.key,
    required this.containerName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: powerOn ? Colors.grey[900] : Color.fromARGB(44, 164, 167, 189),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // icon
              Lottie.asset(
                iconPath,
                height: 65,
                // color: powerOn ? Colors.white : Colors.grey.shade700,
              ),
              Text(
                containerName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: powerOn ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 20),
              // smart device name + switch
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        powerOn == true ? "Drop" : "Idle",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: powerOn ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: pi / -2,
                    child: CupertinoSwitch(
                      activeColor: Color.fromARGB(216, 0, 250, 250),
                      value: powerOn,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
