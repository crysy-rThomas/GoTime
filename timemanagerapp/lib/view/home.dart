// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:timemanagerapp/model/clock_model.dart';
import 'package:timemanagerapp/model/user_model.dart';
import 'package:timemanagerapp/model/working_model.dart';
import 'package:timemanagerapp/service/authentification.dart';
import 'package:timemanagerapp/service/clock_service.dart';
import 'package:timemanagerapp/service/user_service.dart';
import 'package:timemanagerapp/service/working_service.dart';
import 'package:timemanagerapp/utils/loading_screen.dart';
import 'package:timemanagerapp/utils/number_utils.dart';
import 'package:get/get.dart';
import 'package:timemanagerapp/utils/show_snack_bar.dart';
import 'package:tuple/tuple.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double maxheight = 15;
  int? selected;
  bool loading = false;
  List<UserModel> myEmployees = [];
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int userRole = 3;

  final style = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        "$value h",
        style: style,
      ),
    );
  }

  getEmployees() async {
    int? myId = int.tryParse(
        await (const FlutterSecureStorage()).read(key: 'id') ?? "-1");
    if (myId == null) {
      showSnackBar("You are not logged in", isError: true);
      return;
    }
    UserModel? user = await UserService().getUser(myId);
    if (user == null) {
      showSnackBar("You are not logged in", isError: true);
      return;
    }
    final List<UserModel> employees = (await UserService().getAllUsers())
        .where((element) => element.role > user.role)
        .toList();
    user.firstname = "Me";
    user.lastname = "";
    setState(() {
      myEmployees = [user, ...employees];
    });
  }

  Future<Tuple2<List<ClockModel>, List<WorkingModel>>>
      getClocksAndWorking() async {
    List<ClockModel> clocks = await ClockService().getMyClocks();
    List<WorkingModel> workings = await WorkingService().getMyWorkingTimes();
    return Tuple2(clocks, workings);
  }

  List<FlSpot> getWorkingTimesData() {
    List<FlSpot> spots = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime day = now.subtract(Duration(days: i));
      List<WorkingModel> workings = [];
      for (var working in workings) {
        if (working.startTime.day == day.day &&
            working.startTime.month == day.month &&
            working.startTime.year == day.year) {
          workings.add(working);
        }
      }
      double total = 0;
      for (var working in workings) {
        total += working.endTime.difference(working.startTime).inHours;
      }
      spots[i] = FlSpot(i.toDouble(), total);
    }

    return spots;
  }

  List<FlSpot> getClockedData() {
    List<FlSpot> spots = const [
      FlSpot(0, 9),
      FlSpot(1, 2),
      FlSpot(2, 7),
      FlSpot(3, 9),
      FlSpot(4, 2),
      FlSpot(5, 2),
      FlSpot(6, 2),
    ];

    return spots;
  }

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (selected == -1) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Image(
              image: AssetImage("assets/logo_white.png"),
              height: 50,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Add hero",
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
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(248, 249, 250, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: firstnameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Prénom",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                  controller: lastnameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nom",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                  controller: emailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mot de passe",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(248, 249, 250, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<int>(
                  value: userRole,
                  isExpanded: true,
                  elevation: 16,
                  hint: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Center(
                      child: Text(
                        "Choose a role",
                      ),
                    ),
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      userRole = newValue ?? 3;
                    });
                  },
                  items: [
                    {"id": 1, "name": "General Manager"},
                    {"id": 2, "name": "Manager"},
                    {"id": 3, "name": "User"},
                  ].map<DropdownMenuItem<int>>((Map<String, dynamic> value) {
                    return DropdownMenuItem<int>(
                      value: value["id"] as int,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Center(
                          child: Text(
                            value['name'] ?? '',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                if (firstnameController.text.isEmpty) {
                  showSnackBar("Please enter your firstname", isError: true);
                  return;
                }
                if (lastnameController.text.isEmpty) {
                  showSnackBar("Please enter your lastname", isError: true);
                  return;
                }
                if (emailController.text.isEmpty) {
                  showSnackBar("Please enter your email", isError: true);
                  return;
                }
                if (passwordController.text.isEmpty) {
                  showSnackBar("Please enter your password", isError: true);
                  return;
                }
                setState(() {
                  loading = true;
                });
                Authentification()
                    .signUp(
                        emailController.text,
                        passwordController.text,
                        firstnameController.text,
                        lastnameController.text,
                        userRole)
                    .then(
                  (value) {
                    setState(() {
                      loading = false;
                    });
                    if (value) {
                      showSnackBar("Account created");
                      getEmployees();
                      setState(() {
                        emailController.clear();
                        passwordController.clear();
                        firstnameController.clear();
                        lastnameController.clear();
                        userRole = 3;
                        selected = null;
                      });
                    } else {
                      showSnackBar("Error while signing up", isError: true);
                    }
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(101, 126, 233, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                "Créer un compte",
                                style: TextStyle(
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
          ],
        ),
      );
    }
    return FutureBuilder<Tuple2<List<ClockModel>, List<WorkingModel>>>(
      future: getClocksAndWorking(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const LoadingScreen();
        }
        List<ClockModel> clocks = snapshot.data!.item1;
        List<WorkingModel> workings = snapshot.data!.item2;
        List<Widget> widgets = [
          ...myEmployees
              .map((e) => ListTile(
                    onTap: () {
                      setState(() {
                        selected = e.id;
                      });
                    },
                    title: Text(
                      "${e.firstname} ${e.lastname}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    subtitle: Text(
                      "Role: ${e.role}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ))
              .toList()
        ];
        const working = getWorkingTimesData();
        return Scaffold(
          backgroundColor: Colors.black,
          drawer: Drawer(
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      ...widgets,
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          selected = -1;
                        });
                        Navigator.pop(context);
                      },
                      child: Stack(
                        children: [
                          Image.asset("assets/justice-league.png"),
                          Positioned(
                            top: 75,
                            left: size.width * 0.3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Add hero",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
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
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Image(
                image: AssetImage("assets/logo_white.png"),
                height: 50,
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
                  color: Colors.white,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              int? myId = int.tryParse(
                  await (const FlutterSecureStorage()).read(key: 'id') ?? "-1");
              if (myId == null) {
                showSnackBar("You are not logged in", isError: true);
                return;
              }
              await ClockService().clockInOrOut(
                myId,
                (clocks.length % 2 == 0),
                "Clock ${(clocks.length % 2 == 0) ? "in" : "out"} at ${DateFormat("yyyy-mm-dd hh:mm").format(DateTime.now())}",
              );
              setState(() {});
            },
            backgroundColor: Colors.white,
            child: Icon(
              (clocks.length % 2 == 0) ? Icons.timer : Icons.timer_off,
              color: Colors.black,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                  width: size.width,
                ),
                Text(
                  (clocks.length % 2 != 0) ? "Working" : "Not working",
                  style: TextStyle(
                    color: (clocks.length % 2 != 0) ? Colors.red : Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 32,
                  width: size.width,
                ),
                Text(
                  DateFormat("EEEE dd MMMM yyyy").format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
                SizedBox(
                  height: 16,
                  width: size.width,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.9),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 18,
                          top: 10,
                          bottom: 4,
                        ),
                        child: LineChart(
                          LineChartData(
                            lineTouchData: const LineTouchData(enabled: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: ,
                                isCurved: true,
                                barWidth: 2,
                                color: Colors.red,
                                dotData: const FlDotData(
                                  show: false,
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.red.withOpacity(0.2),
                                ),
                              ),
                              LineChartBarData(
                                spots: getClockedData(),
                                isCurved: true,
                                barWidth: 2,
                                color: Colors.green,
                                dotData: const FlDotData(
                                  show: false,
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.green.withOpacity(0.2),
                                ),
                              ),
                            ],
                            minY: 0,
                            maxY: maxheight,
                            borderData: FlBorderData(
                              show: true,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: bottomTitleWidgets,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: leftTitleWidgets,
                                  interval: 1,
                                  reservedSize: 45,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: const FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              drawHorizontalLine: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 30,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Time supposed to work",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 30,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Time worked",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
