import 'dart:developer';

import 'package:intl/intl.dart';

String fromDoubleToString(String? value) {
  NumberFormat format = NumberFormat("###,###,###,##0.00", "fr");

  if (value == null || value.isEmpty) {
    return "0.00";
  } else {
    if (value.contains(',')) {
      value = value.replaceAll(',', '.');
    }
    return format
        .format(double.parse(value.replaceAll(' ', "").replaceAll(',', '')));
  }
}

String fromRoleToName(int role) {
  switch (role) {
    case 1:
      return "General Manager";
    case 2:
      return "Manager";
    case 0:
      return "-";
    default:
      return "User";
  }
}
