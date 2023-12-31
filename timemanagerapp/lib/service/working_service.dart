import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:timemanagerapp/model/clock_model.dart';
import 'package:timemanagerapp/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timemanagerapp/model/working_model.dart';

class WorkingService {
  Future<List<WorkingModel>> getMyWorkingTimes(int? id) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');
    int? myId = id;
    myId ??= int.tryParse(await storage.read(key: 'id') ?? "-1");
    try {
      final res = await Dio()
          .get(
        'https://timemanager-epitech-mpl.gigalixirapp.com/api/working/user/$myId',
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
      List<WorkingModel> workingTimes = [];
      for (var workingTime in res.data['data']) {
        workingTimes.add(WorkingModel.fromJson(workingTime));
      }

      return workingTimes;
    } catch (e) {
      if (kDebugMode) {
        log("getAllWorkingTimes");
        log(e.toString());
      }
      return [];
    }
  }

  Future<String> clockInOrOut(int id, bool status, String description) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');
    try {
      final res = await Dio()
          .post(
        'https://timemanager-epitech-mpl.gigalixirapp.com/api/clock',
        data: {
          "clock": {
            "status": status,
            "description": description,
            "user": id,
            "time": DateFormat("yyyy-MM-dd hh:mm").format(DateTime.now())
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
