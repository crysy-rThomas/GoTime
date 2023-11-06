import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:timemanagerapp/utils/date_picker.dart';
import 'package:tuple/tuple.dart';

class DialogNewDate extends StatefulWidget {
  const DialogNewDate({super.key});

  @override
  State<DialogNewDate> createState() => _DialogNewDateState();
}

class _DialogNewDateState extends State<DialogNewDate> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GiffyDialog.image(
      Image.network(
        "https://media.tenor.com/wrmp9IqHx3AAAAAd/gotham-city.gif",
        height: 200,
        fit: BoxFit.cover,
      ),
      title: const Text(
        'Add a new working time',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              startDate = (await chooseDateTime(
                    context,
                    DateTime.now(),
                  )) ??
                  startDate;
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(248, 249, 250, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_calendar),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("dd/MM/yyyy HH:mm").format(startDate),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              endDate = (await chooseDateTime(
                    context,
                    DateTime.now(),
                  )) ??
                  endDate;
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(248, 249, 250, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_calendar),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("dd/MM/yyyy HH:mm").format(endDate),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, Tuple2(startDate, endDate));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'OK',
          ),
        ),
      ],
    );
  }
}
