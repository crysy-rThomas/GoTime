import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timemanagerapp/service/authentification.dart';
import 'package:timemanagerapp/utils/loading_screen.dart';
import 'package:timemanagerapp/utils/show_snack_bar.dart';
import 'package:tuple/tuple.dart';
import 'package:local_auth/error_codes.dart' as local_auth_error;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController textController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final _localAuthentication = LocalAuthentication();
  final LocalAuthentication auth = LocalAuthentication();
  late List<BiometricType> availableBiometrics;
  bool loading = false;
  bool faceId = false;
  String? email;

  login(Function goToNext, Function(String) error) async {
    setState(() {
      loading = true;
    });
    final Tuple2<bool, String> user =
        await Authentification().signIn(email!, textController.text);
    setState(() {
      loading = false;
    });
    if (user.item1) {
      goToNext();
    } else {
      error(user.item2);
    }
  }

  faceIdFunct(Function goToNext) async {
    setState(() {
      loading = true;
    });
    const FlutterSecureStorage storage = FlutterSecureStorage();
    String? token =
        await (const FlutterSecureStorage()).read(key: 'access_token');
    if (token == null || token.isEmpty) {
      showSnackBar("Token invalide veuillez vous reconnecter", isError: true);
      setState(() {
        loading = false;
        faceId = false;
      });
      return;
    }
    String? face = await storage.read(key: 'faceId');
    if (face == null || face == "true") {
      bool isAuthorized = false;
      try {
        isAuthorized = await _localAuthentication.authenticate(
          localizedReason:
              "Veuillez vous authentifier pour accéder à votre compte",
        );
      } on PlatformException catch (exception) {
        Get.showSnackbar(
          GetSnackBar(
            message:
                "Impossible de vous authentifier avec l'authentification biométrique",
            borderRadius: 10,
            margin: const EdgeInsets.all(16),
            messageText: Text(
              exception.message ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
            backgroundGradient: const LinearGradient(
              colors: [
                Color.fromRGBO(101, 126, 233, 1),
                Color.fromRGBO(117, 76, 163, 1)
              ],
            ),
          ),
        );
      }
      if (isAuthorized) {
        goToNext();
      }
    }
    setState(() {
      loading = false;
    });
  }

  getFaceId() async {
    setState(() {
      loading = true;
    });
    String? face = await storage.read(key: 'faceId');
    availableBiometrics = await auth.getAvailableBiometrics();
    if ((face == null || face == "true")) {
      faceId = true;
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getFaceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (email != null)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  textController.text = email!;
                                  email = null;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Center(
                        child: Image(
                          image: const AssetImage('assets/square_logo.png'),
                          fit: BoxFit.fitWidth,
                          width: size.width,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: 432,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SelectableText(
                                email == null
                                    ? "Saisir votre identifiant"
                                    : "Saisir votre mot de passe",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(248, 249, 250, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    controller: textController,
                                    obscureText: email != null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              GestureDetector(
                                onTap: () {
                                  if (email == null) {
                                    if (textController.text.isNotEmpty) {
                                      email = textController.text;
                                      textController.clear();
                                      setState(() {});
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: SelectableText(
                                              "Veuillez entrer un email"),
                                        ),
                                      );
                                    }
                                  } else {
                                    if (textController.text.isNotEmpty) {
                                      TextInput.finishAutofillContext();
                                      login(
                                        () {
                                          Navigator.pushReplacementNamed(
                                              context, '/home');
                                        },
                                        (String error) {
                                          showSnackBar(error, isError: true);
                                        },
                                      );
                                    } else {
                                      showSnackBar(
                                          "Veuillez entrer un mot de passe",
                                          isError: true);
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(101, 126, 233, 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: loading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Text(
                                                  email == null
                                                      ? "Continuer"
                                                      : "Se connecter",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (faceId) const SizedBox(height: 20),
                              if (faceId)
                                GestureDetector(
                                  onTap: () async {
                                    faceIdFunct(
                                      () async {
                                        await (const FlutterSecureStorage())
                                            .write(
                                                key: 'loggedIn', value: "true");
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          248, 249, 250, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              availableBiometrics.contains(
                                                      BiometricType.face)
                                                  ? Image.asset(
                                                      "assets/face_id.png",
                                                      width: 28,
                                                      height: 28,
                                                    )
                                                  : const Icon(
                                                      Icons.fingerprint,
                                                      color: Colors.black,
                                                      size: 28,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const SelectableText(
                        "Copyright © Qhare.fr 2023",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          return SelectableText(
                            snapshot.hasData && snapshot.data != null
                                ? "Version ${snapshot.data!.version}"
                                : "Version",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (loading) const LoadingScreen(),
          ],
        ),
      );
    });
  }
}
