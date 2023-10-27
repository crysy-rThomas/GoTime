import 'dart:developer';

import 'package:get/get.dart' as getx;
import 'package:timemanagerapp/model/user_model.dart';
import 'package:timemanagerapp/service/user_service.dart';
import 'package:timemanagerapp/utils/internet_service.dart';
import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authentification {
  Future<Tuple2<bool, String>> signIn(String email, String password) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    try {
      final res = await Dio().post(
        'https://timemanager-epitech-mpl.gigalixirapp.com/api/login',
        data: {
          "email": email,
          "password": password,
        },
      ).onError((DioError error, stackTrace) async {
        return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: error.response?.statusCode ?? 0,
          data: error.response?.data ?? {},
        );
      });
      if (res.statusCode != 200) {
        storage.delete(key: 'refresh_token');
        return Tuple2(false, res.data["message"]);
      }
      storage.write(key: 'access_token', value: res.data['data']['token']);
      storage.write(key: 'loggedIn', value: "true");
      List<UserModel> users = await UserService().getAllUsers();
      int myId =
          users.firstWhereOrNull((element) => element.email == email)?.id ?? -1;
      storage.write(key: 'id', value: myId.toString());
      return const Tuple2(true, "");
    } catch (e) {
      if (kDebugMode) {
        log("SignIn");
        log(e.toString());
      }
      return const Tuple2(
          false, "Une erreur est survenue, merci de réessayer plus tard");
    }
  }

  Future<void> signOut() async {
    await (const FlutterSecureStorage()).delete(key: 'loggedIn');
  }

  Future<bool> isSignedIn() async {
    String? loggedIn =
        await (const FlutterSecureStorage()).read(key: 'loggedIn');
    return loggedIn != null && loggedIn.isNotEmpty;
  }
}
