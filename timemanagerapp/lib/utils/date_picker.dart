import 'package:flutter/material.dart';

Future<DateTime?> chooseDate(context, date) async {
  return await showDatePicker(
    context: context,
    initialDate: date,
    locale: const Locale('fr', ''),
    firstDate: DateTime(1910),
    lastDate: DateTime(2030),
    helpText: 'Sélectionner la date',
    confirmText: 'Ok',
    cancelText: 'Annuler',
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  16.0), // this is the border radius of the picker
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: const Color.fromRGBO(101, 126, 233, 1),
            onPrimary: Colors.white,
          ),
          dialogBackgroundColor: const Color.fromRGBO(248, 249, 250, 1),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(
                101,
                126,
                233,
                1,
              ),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}

Future<DateTime?> chooseDateTime(context, DateTime date) async {
  DateTime? res = await showDatePicker(
    context: context,
    initialDate: date,
    locale: const Locale('fr', ''),
    firstDate: DateTime(1910),
    lastDate: DateTime.now().add(
      const Duration(days: 1),
    ),
    helpText: 'Choose a date',
    confirmText: 'Ok',
    cancelText: 'Cancel',
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  16.0), // this is the border radius of the picker
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: const Color.fromRGBO(101, 126, 233, 1),
            onPrimary: Colors.white,
          ),
          dialogBackgroundColor: const Color.fromRGBO(248, 249, 250, 1),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(
                101,
                126,
                233,
                1,
              ),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (res == null) {
    return null;
  }
  TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
    initialEntryMode: TimePickerEntryMode.dial,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  16.0), // this is the border radius of the picker
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: const Color.fromRGBO(101, 126, 233, 1),
            onPrimary: Colors.white,
          ),
          dialogBackgroundColor: const Color.fromRGBO(248, 249, 250, 1),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(
                101,
                126,
                233,
                1,
              ),
            ),
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox(),
        ),
      );
    },
  );
  if (res != null && time != null) {
    return DateTime(
      res.year,
      res.month,
      res.day,
      time.hour,
      time.minute,
    );
  }
}

Future<TimeOfDay?> chooseTime(context, date) async {
  TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
    initialEntryMode: TimePickerEntryMode.dial,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  16.0), // this is the border radius of the picker
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: const Color.fromRGBO(101, 126, 233, 1),
            onPrimary: Colors.white,
          ),
          dialogBackgroundColor: const Color.fromRGBO(248, 249, 250, 1),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(
                101,
                126,
                233,
                1,
              ),
            ),
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox(),
        ),
      );
    },
  );
  return time;
}

Future<DateTimeRange?> chooseRange(context, date) async {
  return await showDateRangePicker(
    context: context,
    locale: const Locale('fr', ''),
    firstDate: DateTime(1910),
    lastDate: DateTime(2030),
    helpText: 'Sélectionner la date',
    confirmText: 'Ok',
    cancelText: 'Annuler',
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  16.0), // this is the border radius of the picker
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: const Color.fromRGBO(101, 126, 233, 1),
            onPrimary: Colors.white,
          ),
          dialogBackgroundColor: const Color.fromRGBO(248, 249, 250, 1),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(
                101,
                126,
                233,
                1,
              ),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
