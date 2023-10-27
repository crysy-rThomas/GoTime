import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar(String text, {bool isError = false, Function? onTap = null}) {
  return Get.showSnackbar(
    GetSnackBar(
      message: text,
      borderRadius: 10,
      margin: const EdgeInsets.all(16),
      messageText: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      onTap: (snack) => onTap,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundGradient: LinearGradient(
        colors: isError
            ? [
                Color.fromRGBO(255, 101, 101, 1),
                Color.fromRGBO(255, 101, 101, 1)
              ]
            : [
                Color.fromRGBO(101, 126, 233, 1),
                Color.fromRGBO(117, 76, 163, 1)
              ],
      ),
    ),
  );
}
