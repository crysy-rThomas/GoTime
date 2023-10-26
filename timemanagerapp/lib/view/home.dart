// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timemanagerapp/model/user_model.dart';
import 'package:timemanagerapp/service/authentification.dart';
import 'package:timemanagerapp/service/user_service.dart';
import 'package:timemanagerapp/utils/loading_screen.dart';
import 'package:timemanagerapp/utils/number_utils.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Image(
            image: AssetImage("assets/logo.png"),
          ),
        ),
        title: const Text(
          "Home",
          style: TextStyle(
            color: Color.fromRGBO(72, 80, 86, 1),
            fontSize: 23,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(
              Icons.settings,
              color: Color.fromRGBO(72, 80, 86, 1),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: UserService().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  UserModel user = snapshot.data![index];
                  return ListTile(
                    title:
                        Text("${user.id}: ${user.firstname} ${user.lastname}"),
                    subtitle:
                        Text("${user.email} / ${fromRoleToName(user.role)}"),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Aucun utilisateur"),
              );
            }
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
