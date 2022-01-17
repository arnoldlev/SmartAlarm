// Arnold Lev

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:first_app/alarm_page.dart';
import 'package:first_app/database_helper.dart';
import 'package:flutter/material.dart';

import 'alarm.dart';
import 'navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBProvider.database = await DBProvider.initDB();
  Alarm.alarms = await DBProvider.retrieveAlarms();
  runApp(const MyApp());
  await AndroidAlarmManager.initialize();
  for (Alarm a in Alarm.alarms) {
      if (a.isEnabled() && a.time.isAfter(DateTime.now())) {
        AndroidAlarmManager.oneShotAt(
            a.time, a.id, AlarmPageState.handleAlarm, exact: true,
            wakeup: true);
      } else {
        a.enabled = false;
      }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Clock',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const AlarmPage(),
      navigatorKey: NavigationService.navigatorKey,
    );
  }
}
