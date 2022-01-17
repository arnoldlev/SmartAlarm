import 'dart:math';

class Alarm {

  static late List<Alarm> alarms;

  late int id;
  DateTime time;
  bool enabled;

  Alarm({required this.time, required this.enabled}) {
    id = Random().nextInt(pow(2, 31).toInt());
  }

  static List<Alarm> getAlarms() {
    return alarms;
  }

  int getID() {
    return id;
  }

  DateTime getTime() {
    return time;
  }

  bool isEnabled() {
    return enabled;
  }

  Alarm.fromMap(Map<String, dynamic> res)
      : id = res["id"],
      time = DateTime.parse(res["time"]),
      enabled = (res["enabled"] == 1) ? true : false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'enabled': (enabled) ? 1 : 0,
    };
  }


}