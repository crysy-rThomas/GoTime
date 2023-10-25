import 'package:flutter/material.dart';
import 'package:timemanagerapp/view/splashscreen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    "/": (context) => const Splashscreen(),
    // "/login": (context) => const LoginScreen(),
  };

  static String initial = '/';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
