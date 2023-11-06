// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timemanagerapp/model/user_model.dart';
import 'package:timemanagerapp/service/authentification.dart';
import 'package:timemanagerapp/service/user_service.dart';
import 'package:timemanagerapp/utils/alert_deconnect.dart';
import 'package:timemanagerapp/utils/alert_delete.dart';
import 'package:timemanagerapp/utils/number_utils.dart';
import 'package:timemanagerapp/utils/show_snack_bar.dart';
import 'package:timemanagerapp/utils/user_small_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool notifications = false;
  UserModel? user;
  bool faceId = false;
  String? email;
  String? password;

  getEverything() async {
    String? notif = await storage.read(key: 'notifications');
    String? face = await storage.read(key: 'faceId');
    email = await storage.read(key: 'email');
    password = await storage.read(key: 'password');
    int? myId = int.tryParse(await storage.read(key: 'id') ?? "-1");
    if (myId != null && myId != -1) {
      user = await UserService().getUser(myId);
    }
    setState(() {
      notifications = notif == 'false' ? false : true;
      faceId = face == 'false' ? false : true;
    });
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      showSnackBar("Impossible d'ouvrir le lien", isError: true);
    }
  }

  @override
  void initState() {
    getEverything();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const SelectableText(
          "Préférences",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SelectableText(
                      'Personal information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(145, 150, 154, 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: UserSmallInfo(
                        title: "Firstname",
                        data: email ?? '-',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: UserSmallInfo(
                        title: "Lastname",
                        data: password ?? '-',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: UserSmallInfo(
                        title: "Role",
                        data: fromRoleToName(user?.role ?? 0),
                      ),
                    ),
                  ],
                ),
              const SelectableText(
                'Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(145, 150, 154, 1),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SelectableText(
                      "Face ID",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(34, 34, 34, 1),
                      ),
                    ),
                    Switch(
                      value: faceId,
                      onChanged: (value) async {
                        setState(() {
                          faceId = value;
                        });
                        await storage.write(
                            key: 'faceId', value: value.toString());
                      },
                      activeColor: const Color.fromRGBO(52, 2, 108, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SelectableText(
                'Support',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(145, 150, 154, 1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const SelectableText(
                      "If you have any questions, please contact us at :",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(72, 80, 86, 1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        await _launchUrl(
                          "mailto:richard2.depierre@epitech.eu",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        splashFactory: NoSplash.splashFactory,
                        enableFeedback: false,
                      ),
                      child: const Text(
                        "richard2.depierre@epitech.eu",
                        style: TextStyle(
                          color: Color.fromRGBO(101, 126, 233, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SelectableText(
                'Legal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(145, 150, 154, 1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(34, 34, 34, 1),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _launchUrl(
                          "https://richard-depierre.github.io/beafter-privacy-policy/",
                        );
                      },
                      icon: const Icon(
                        Icons.launch,
                        color: Color.fromRGBO(145, 150, 154, 1),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'End-User License Agreement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(34, 34, 34, 1),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _launchUrl(
                          "https://richard-depierre.github.io/beafter-privacy-policy/eurl",
                        );
                      },
                      icon: const Icon(
                        Icons.launch,
                        color: Color.fromRGBO(145, 150, 154, 1),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 32,
                ),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    bool res = await showDialog(
                      context: context,
                      builder: (context) {
                        return alertDeconnect(context);
                      },
                    );
                    if (res) {
                      await Authentification().signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    splashFactory: NoSplash.splashFactory,
                    enableFeedback: false,
                  ),
                  child: const Text(
                    "Log out",
                    style: TextStyle(
                      color: Color.fromRGBO(52, 2, 108, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    bool res = await showDialog(
                      context: context,
                      builder: (context) {
                        return alertDelete(context);
                      },
                    );
                    if (res) {
                      await Authentification().deleteAccount();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    splashFactory: NoSplash.splashFactory,
                    enableFeedback: false,
                  ),
                  child: const Text(
                    "Delete my account",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
