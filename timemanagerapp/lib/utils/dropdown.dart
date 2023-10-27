import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyDropDownButton extends StatelessWidget {
  const MyDropDownButton(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.items});

  final dynamic value;
  final Function onChanged;
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final padding = MediaQueryData.fromWindow(ui.window).padding;
    return DropdownButton(
      value: value,
      hint: const Text("Sélectionner"),
      underline: Container(),
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      onChanged: (newValue) {
        onChanged(newValue);
      },
      items: items.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: SizedBox(
            width: size.width - 80 - padding.left - padding.right,
            child: Text(value.toString()),
          ),
        );
      }).toList(),
    );
  }
}
