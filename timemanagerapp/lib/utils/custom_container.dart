import 'package:flutter/material.dart';

Container myCustomContainer(String text, Color boxColor, Color textColor) {
  return Container(
    decoration: BoxDecoration(
      color: boxColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
