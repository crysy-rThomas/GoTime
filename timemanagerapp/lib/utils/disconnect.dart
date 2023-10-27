import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class DisconnectUser {
  Future disconnect(Function popEverything) async {
    Get.showSnackbar(
      const GetSnackBar(
        message: "Déconnexion réussie, à bientôt !",
        borderRadius: 10,
        margin: EdgeInsets.all(16),
        messageText: Text(
          "Déconnexion réussie, à bientôt !",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        backgroundGradient: LinearGradient(
          colors: [
            Color.fromRGBO(101, 126, 233, 1),
            Color.fromRGBO(117, 76, 163, 1)
          ],
        ),
      ),
    );
    popEverything();
  }
}
