import 'dart:isolate';
import 'dart:ui';

import 'package:first_app/alarm_notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'alarm.dart';
import 'database_helper.dart';
import 'navigation.dart';

const String isolateName = 'isolate';
final ReceivePort port = ReceivePort();


class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  AlarmPageState createState() => AlarmPageState();
}

class AlarmPageState extends State<AlarmPage> {

  static SendPort? uiSendPort;
  static List<Alarm> alarms = Alarm.getAlarms();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );

    port.listen((_) async => NavigationService.push(const AlarmNotification()));
  }

  static void handleAlarm() {
     uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
     uiSendPort?.send(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Alarm",
        onPressed: () {
          Alarm a = Alarm(time: DateTime.now(), enabled: true);
          DatePicker.showDateTimePicker(context, showTitleActions: true,
              onConfirm: (date) {
                a.time = date;
                a.enabled = true;
                DBProvider.insertAlarm(a);
                AndroidAlarmManager.oneShotAt(a.time, a.id, AlarmPageState.handleAlarm, exact: true, wakeup: true);
                alarms.add(a);
                setState(() {

                });
              }, currentTime: DateTime.now());

          setState(() {

          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                  children: [
                    IconButton(onPressed: () {
                        DBProvider.deleteAlarm(alarms[index]);
                        AndroidAlarmManager.cancel(alarms[index].id);
                        Alarm.alarms.removeAt(index);
                        setState(() {

                        });
                    }, icon: const Icon(Icons.delete)),
                    Text(DateFormat.yMd().add_jm().format(alarms[index].time),
                     style: const TextStyle(fontSize: 20)
                    ),
                    const Spacer(),
                    Switch(
                        value: alarms[index].enabled,
                        onChanged: (value) {
                            alarms[index].enabled = value;
                            DBProvider.updateAlarm(alarms[index]);
                            setState(() {   });
                            if (value == true) {
                              Future<bool> result = AndroidAlarmManager.oneShotAt(alarms[index].time, alarms[index].id, handleAlarm, exact: true, wakeup: true);
                            } else {
                              AndroidAlarmManager.cancel(alarms[index].id);
                            }
                          },
                        activeColor: Colors.green,
                     ),
                  ],
              ),
            );
      })
    );
  }
}