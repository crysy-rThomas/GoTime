// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timemanagerapp/service/authentification.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Future<bool> getInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return await Authentification().isSignedIn();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder<bool>(
      future: getInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
          }
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Image(
                  image: AssetImage("assets/logo.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
