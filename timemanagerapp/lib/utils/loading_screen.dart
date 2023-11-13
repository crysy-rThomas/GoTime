import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: Image(
          image: AssetImage("assets/loading.gif"),
          height: 96,
        ),
      ),
    );
  }
}
