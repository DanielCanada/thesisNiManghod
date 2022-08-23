import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_case_timer_app/pages/initial_main_page.dart';
import 'package:pill_case_timer_app/pages/onBoarding%20pages/first_page.dart';
import 'package:pill_case_timer_app/pages/onBoarding%20pages/second_page.dart';
import 'package:pill_case_timer_app/pages/onBoarding%20pages/third_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // page controller - keeps track on what page we're on
  final PageController _controller = PageController();

  // check if last page
  bool onLastPage = false;

  final navFont = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const IntroPage1(),
              const IntroPage2(),
              const IntroPage3(),
            ],
          ),

          // page indicator
          Container(
              alignment: const Alignment(0, 0.80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // skip
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.fjallaOne(
                        textStyle: navFont,
                      ),
                    ),
                  ),
                  // dot indicator
                  SmoothPageIndicator(controller: _controller, count: 3),

                  // next / done
                  onLastPage
                      ? GestureDetector(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('showAuth', true);

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InitialMainPage()));
                          },
                          child: Text(
                            "Done",
                            style: GoogleFonts.fjallaOne(
                              textStyle: navFont,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text(
                            "Next",
                            style: GoogleFonts.fjallaOne(
                              textStyle: navFont,
                            ),
                          ),
                        ),
                ],
              ))
        ],
      ),
    );
  }
}
