import 'package:flutter/material.dart';
import 'package:timemanagerapp/view/home.dart';
import 'package:timemanagerapp/view/login.dart';
import 'package:timemanagerapp/view/settings.dart';
import 'package:timemanagerapp/view/splashscreen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    "/": (context) => const Splashscreen(),
    "/login": (context) => const LoginScreen(),
    "/home": (context) => const HomePage(),
    "/settings": (context) => const Settings(),
  };

  static String initial = '/';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
