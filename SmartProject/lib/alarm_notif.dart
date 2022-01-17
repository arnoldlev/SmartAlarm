import 'package:first_app/puzzle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlarmNotification extends StatefulWidget {

  const AlarmNotification({Key? key}) : super(key: key);

  @override
  _AlarmNotificationState createState() => _AlarmNotificationState();
}

class _AlarmNotificationState extends State<AlarmNotification> {

  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer.playAlarm(asAlarm: true);
  }

  var answer = TextEditingController();
  Puzzle puzzle = Puzzle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Text("Alarm Alarming", style: TextStyle(fontSize: 30, color: Colors.red)),
            Text("What is ${puzzle.op1} + ${puzzle.op2} ?", style: const TextStyle(fontSize: 20, color: Colors.red)),
            TextField(
              controller: answer,
              obscureText: false,
              decoration: const InputDecoration( border: OutlineInputBorder(), labelText: 'Enter answer',)),
            ElevatedButton(
              onPressed: () {
                if (answer.text == puzzle.getAnswer().toString()) {
                    FlutterRingtonePlayer.stop();
                    Navigator.pop(context);
                } else {
                  answer.text = "Try Again";
                }
              },
              child: const Icon(Icons.stop),
            )
          ],
        )
    );
  }
}