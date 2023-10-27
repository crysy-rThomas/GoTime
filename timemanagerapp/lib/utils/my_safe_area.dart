import 'package:flutter/material.dart';

class MySafeArea extends StatelessWidget {
  const MySafeArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      bool isPortrait = (orientation == Orientation.portrait);
      if (isPortrait) {
        return child;
      }
      return SafeArea(child: child);
    },);
  }
}