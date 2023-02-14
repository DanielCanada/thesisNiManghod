import 'package:flutter/material.dart';
import 'package:pill_case_timer_app/pages/calendar/api/notifications_api.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  // FlutterSound flutterSound = FlutterSound();
  // StreamSubscription _subscription;

  late final LocalNotificationService service;

  @override
  void initState() {
    super.initState();
    // Play the alarm sound.
    // _subscription = flutterSound.play(alarmSoundFilePath).listen((event) {});
  }

  @override
  void dispose() {
    super.dispose();
    // _subscription.cancel();
  }

  void _cancelAlarm() {
    // Cancel the scheduled notification.
    service.cancelNotif(0);
    // Stop the alarm sound.
    // _subscription.cancel();
    // Pop the AlarmScreen.
    Navigator.pop(context);
  }

  void _snoozeAlarm() {
    // Cancel the scheduled notification.
    service.cancelNotif(0);
    // Stop the alarm sound.
    // _subscription.cancel();
    // Pop the AlarmScreen.
    Navigator.pop(context);
    // Schedule a new notification to be shown in 10 minutes.
    final scheduledDateTime = DateTime.now().add(const Duration(minutes: 10));
    service.showScheduledNotification(
      id: 0,
      title: 'HI',
      body: 'HOYYYYYYYYYYYYYYYYYYY',
      time: scheduledDateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Alarm'),
          ElevatedButton(
            onPressed: _cancelAlarm,
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _snoozeAlarm,
            child: Text('Snooze'),
          ),
        ],
      ),
    );
  }
}
