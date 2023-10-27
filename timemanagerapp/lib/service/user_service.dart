import 'dart:developer';

import 'package:timemanagerapp/model/user_model.dart';
import 'package:timemanagerapp/utils/internet_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  Future<List<UserModel>> getAllUsers() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');
    print(token);
    try {
      final res = await Dio()
          .get(
        'https://timemanager-epitech-mpl.gigalixirapp.com/api/users',
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
      print(res.statusCode);
      print(res.data);
      if (res.statusCode != 200) {
        return [];
      }
      List<UserModel> users = [];
      for (var user in res.data['data']) {
        users.add(UserModel.fromJson(user));
      }

      return users;
    } catch (e) {
      if (kDebugMode) {
        log("getAllUsers");
        log(e.toString());
      }
      return [];
    }
  }

  Future<UserModel?> getUser(int id) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'access_token');
    try {
      print(id);
      final res = await Dio()
          .get(
        'https://timemanager-epitech-mpl.gigalixirapp.com/api/users/$id',
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
      print(res.statusCode);
      print(res.data);
      if (res.statusCode != 200) {
        return null;
      }
      return UserModel.fromJson(res.data['data']);
    } catch (e) {
      if (kDebugMode) {
        log("getUser");
        log(e.toString());
      }
      return null;
    }
  }
}
