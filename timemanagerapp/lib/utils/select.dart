import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MySelect extends StatefulWidget {
  const MySelect({
    super.key,
    required this.title,
    required this.items,
    required this.item,
    required this.getText,
    required this.getValue,
    required this.onChanged,
    required this.checkRequired,
    required this.isRequired,
  });

  final String title;
  final List<dynamic> items;
  final dynamic item;
  final String Function(dynamic) getText;
  final dynamic Function(dynamic) getValue;
  final void Function(dynamic) onChanged;
  final bool Function() checkRequired;
  final bool isRequired;

  @override
  State<MySelect> createState() => _MySelectState();
}

class _MySelectState extends State<MySelect> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final padding = MediaQueryData.fromWindow(ui.window).padding;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SelectableText(
              widget.title,
              style: const TextStyle(
                color: Color.fromRGBO(72, 80, 86, 1),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            if (widget.isRequired)
              const SelectableText(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(248, 249, 250, 1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.checkRequired() ? Colors.red : Colors.transparent,
              width: 1,
            ),
          ),
          child: DropdownButton(
            value: widget.item,
            underline: Container(),
            icon: const Icon(Icons.arrow_drop_down),
            hint: SizedBox(
              width: size.width - 58 - padding.left - padding.right,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(widget.title),
              ),
            ),
            items: widget.items
                .map((e) => DropdownMenuItem(
                      value: widget.getValue(e),
                      child: SizedBox(
                        width: size.width - 58 - padding.left - padding.right,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.getText(e)),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
