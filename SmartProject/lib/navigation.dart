import 'package:flutter/material.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static push(Widget page) => navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => page),
  );

  static pop() => navigatorKey.currentState?.pop();
}