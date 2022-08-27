import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pill_case_timer_app/pages/calendar/calendar_events.dart';
import 'package:pill_case_timer_app/pages/calendar/calendar_example.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CalendarPage> {
  // test 1 widget
  Widget buildCalendarTest01() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          ElevatedButton(
            child: const Text('Events'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Calendar()),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      );

  final _calendarControllerToday = AdvancedCalendarController.today();
  final _calendarControllerCustom =
      AdvancedCalendarController.custom(DateTime.now());
  final List<DateTime> events = [
    DateTime.utc(2022, 08, 23, 05),
    DateTime.utc(2022, 08, 25, 10)
  ];

  Widget buildSFCalendar() => AdvancedCalendar(
        controller: _calendarControllerCustom,
        events: events,
        weekLineHeight: 48.0,
        startWeekDay: 1,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            buildCalendarTest01(),
            buildSFCalendar(),
          ],
        )),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
