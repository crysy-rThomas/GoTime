import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    if (hexString.contains('#') == false) {
      if (hexString == 'orange') {
        return Colors.orange;
      } else if (hexString == 'green') {
        return Colors.green;
      }
      return Colors.red;
    }
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  static Tuple2<Color, Color> getColorFromHtml(String html) {
    if (html.contains('badge-success')) {
      return Tuple2(fromHex('#3ac47d'), Colors.white);
    } else if (html.contains('badge-alternate')) {
      return Tuple2(fromHex('#794c8a'), Colors.white);
    } else if (html.contains('badge-dark')) {
      return Tuple2(fromHex('#343a40'), Colors.white);
    } else if (html.contains('badge-light')) {
      return Tuple2(fromHex('#eeeeee'), fromHex('#212529'));
    } else if (html.contains('badge-danger')) {
      return Tuple2(fromHex('#d92550'), Colors.white);
    } else if (html.contains('badge-focus')) {
      return Tuple2(fromHex('#444054'), Colors.white);
    } else if (html.contains('badge-warning')) {
      return Tuple2(fromHex('#f7b924'), fromHex('#212529'));
    } else if (html.contains('badge-info')) {
      return Tuple2(fromHex('#16aaff'), Colors.white);
    } else if (html.contains('badge-secondary')) {
      return Tuple2(fromHex('#6c757d'), Colors.white);
    } else if (html.contains('background-color')) {
      return Tuple2(
          fromHex(html.split('background-color:').last.split(';').first),
          Colors.white);
    }
    return Tuple2(fromHex("#34026c"), Colors.white);
  }
  static Tuple2<Color, Color> getColorFromInterventionType(String intervention) {
    switch (intervention) {
      case "Commerciale":
        return Tuple2(fromHex('#6c757d'), Colors.white);
      case "SAV":
        return Tuple2(fromHex('#f7b924'), fromHex('#212529'));
      case "Installation":
        return Tuple2(fromHex('#16aaff'), Colors.white);
      case "Pré-visite":
        return Tuple2(fromHex('#343a40'), Colors.white);
      case "Etude Energétique":
        return Tuple2(fromHex('#3ac47d'), Colors.white);
      default:
        return Tuple2(fromHex('#eeeeee'), fromHex('#212529'));
    }
  }
}
