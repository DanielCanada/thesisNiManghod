import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // style of title
  final titleFont = const TextStyle(fontSize: 45, fontWeight: FontWeight.bold);

  final buttonFont = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
            child: Column(
              children: [
                Text(
                  'PILL',
                  style: titleFont,
                ),
                Text(
                  'CASE',
                  style: titleFont,
                ),
                Text(
                  'TIMER',
                  style: titleFont,
                ),
                const SizedBox(height: 20),
                // schedule button
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextButton(
                    onPressed: () {
                      debugPrint('Schedule Button Clicked');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 4.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.purpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Schedule', style: buttonFont),
                    ),
                  ),
                ),
                // Log button
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextButton(
                    onPressed: () {
                      debugPrint('Log Button Clicked');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 4.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.purpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Log', style: buttonFont),
                    ),
                  ),
                ),
                // Settings button
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextButton(
                    onPressed: () {
                      debugPrint('Settings Button Clicked');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 4.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.purpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Settings', style: buttonFont),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/image_1.jpg'),
                      height: 220,
                      width: 220,
                    ),
                    Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const SizedBox(height: 160),
                        const Text("©chronus  V1.01"),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
