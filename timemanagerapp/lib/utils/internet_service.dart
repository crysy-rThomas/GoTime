import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetService {
  InternetService();
  Future<bool> get isConnected async {
    try {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        bool check = await InternetConnectionChecker().hasConnection;
        return check;
      }
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      if (kDebugMode) print("isConnected");
      inspect(e);
      return false;
    }
  }
}
