import 'package:flutter/material.dart';

class MyMarker extends StatelessWidget {
  const MyMarker(
      {super.key,
      required this.globalKeyMyWidget,
      required this.markerColor,
      this.isMe});
  final GlobalKey globalKeyMyWidget;
  final Color markerColor;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.all(
              isMe == true ? 22 : 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Icon(
          isMe == true ? Icons.location_history : Icons.location_on,
          color: isMe == true ? Colors.blue : markerColor,
          size: isMe == true ? 130 : 100,
        ),
      ]),
    );
  }
}
