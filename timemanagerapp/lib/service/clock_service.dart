import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:timemanagerapp/model/clock_model.dart';
import 'package:timemanagerapp/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClockService {
  Future<List<ClockModel>> getMyClocks(int? id) async {
    log(id.toString());
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');
    int? myId = id;
    myId ??= int.tryParse(await storage.read(key: 'id') ?? "-1");
    try {
      final res = await Dio()
          .get(
        'https://timemanager-epitech-mpl.gigalixirapp.com/api/clocks/user/$myId',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      )
          .onError((DioError error, stackTrace) async {
        return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: error.response?.statusCode ?? 0,
          data: error.response?.data ?? {},
        );
      });
      if (res.statusCode != 200) {
        return [];
      }
      List<ClockModel> clocks = [];
      for (var clock in res.data['data']) {
        clocks.add(ClockModel.fromJson(clock));
      }

      return clocks;
    } catch (e) {
      if (kDebugMode) {
        log("getAllClocks");
        log(e.toString());
      }
      return [];
    }
  }

  Future<String> clockInOrOut(
      int id, bool status, String description, DateTime date) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');
    try {
      final res = await Dio()
          .post(
        'https://timemanager-epitech-mpl.gigalixirapp.com/api/clocks',
        data: {
          "clock": {
            "status": status,
            "description": description,
            "user": id,
            "time": DateFormat("yyyy-MM-dd HH:mm").format(date),
          }
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      )
          .onError((DioError error, stackTrace) async {
        return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: error.response?.statusCode ?? 0,
          data: error.response?.data ?? {},
        );
      });
      if (res.statusCode != 200) {
        return "Error while clocking";
      }
      return "Clocked ${status ? 'in' : 'out'}";
    } catch (e) {
      if (kDebugMode) {
        log("clockInOrOut");
        log(e.toString());
      }
      return "Error while clocking";
    }
  }
}
