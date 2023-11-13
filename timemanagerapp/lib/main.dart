import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart' as loc;

import 'package:get/get.dart';
import 'package:timemanagerapp/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gotime Manager',
      debugShowCheckedModeBanner: true,
      routes: Routes.list,
      themeMode: ThemeMode.light,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
      localizationsDelegates: const [
        loc.GlobalMaterialLocalizations.delegate,
        loc.GlobalWidgetsLocalizations.delegate,
        loc.GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''),
      ],
    );
  }
}
