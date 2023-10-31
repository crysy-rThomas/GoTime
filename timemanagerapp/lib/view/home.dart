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
import 'package:timemanagerapp/utils/indicator.dart';
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
  bool loadingPage = false;
  List<UserModel> myEmployees = [];
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int userRole = 3;
  List<ClockModel> fullClocks = [];
  List<WorkingModel> fullWorkings = [];
  Duration totalWorkingTime = Duration(seconds: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int touchedIndex = -1;

  final style = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    DateTime now = DateTime.now();

    switch (value.toInt()) {
      case 0:
        text = DateFormat("EE").format(now.subtract(const Duration(days: 6)));
        break;
      case 1:
        text = DateFormat("EE").format(now.subtract(const Duration(days: 5)));
        break;
      case 2:
        text = DateFormat("EE").format(now.subtract(const Duration(days: 4)));
        break;
      case 3:
        text = DateFormat("EE").format(now.subtract(const Duration(days: 3)));
        break;
      case 4:
        text = DateFormat("EE").format(now.subtract(const Duration(days: 2)));
        break;
      case 5:
        text = DateFormat("EE").format(now.subtract(const Duration(days: 1)));
        break;
      case 6:
        text = DateFormat("EE").format(now);
        break;
      default:
        text = "";
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
    setState(() {
      loadingPage = true;
    });
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
    await getClocksAndWorking();
    updateClock();
    setState(() {
      myEmployees = [user, ...employees];
      loadingPage = false;
    });
  }

  updateClock() async {
    while (true) {
      if (fullClocks.length % 2 != 0) {
        fullClocks.sort(
          (a, b) {
            return a.time.compareTo(b.time);
          },
        );
        totalWorkingTime = DateTime.now().difference(fullClocks.last.time);
      }
      setState(() {});
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<Tuple2<List<ClockModel>, List<WorkingModel>>>
      getClocksAndWorking() async {
    setState(() {
      loadingPage = true;
    });
    fullClocks = await ClockService().getMyClocks(selected);
    fullWorkings = await WorkingService().getMyWorkingTimes(selected);
    print(fullClocks);
    print(fullWorkings);
    setState(() {
      loadingPage = false;
    });
    return Tuple2(fullClocks, fullWorkings);
  }

  List<FlSpot> getWorkingTimesData() {
    List<FlSpot> spots = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(now.year, now.month, now.day - i);
      double time = 0;
      for (WorkingModel working in fullWorkings) {
        if (working.startTime.day == day.day &&
            working.startTime.month == day.month &&
            working.startTime.year == day.year) {
          time += working.endTime.difference(working.startTime).inMinutes;
        }
      }
      spots.add(FlSpot(i.toDouble(), (time ~/ 60).toDouble()));
    }

    return spots;
  }

  Duration getTotalWorkingTime() {
    int spots = 0;
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(now.year, now.month, now.day - i);
      double time = 0;
      for (WorkingModel working in fullWorkings) {
        if (working.startTime.day == day.day &&
            working.startTime.month == day.month &&
            working.startTime.year == day.year) {
          time += working.endTime.difference(working.startTime).inSeconds;
        }
      }
      spots += time.toInt();
    }

    return Duration(seconds: spots);
  }

  Duration getTotalClockTime() {
    int spots = 0;
    DateTime now = DateTime.now();
    List<ClockModel> clocks = fullClocks;
    clocks.sort(
      (a, b) {
        return a.time.compareTo(b.time);
      },
    );
    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(now.year, now.month, now.day - i);
      double time = 0;
      List clocksOfTheDay = clocks.where((element) {
        return element.time.day == day.day &&
            element.time.month == day.month &&
            element.time.year == day.year;
      }).toList();
      for (int i = 0; i < clocksOfTheDay.length; i += 2) {
        if (i + 1 >= clocksOfTheDay.length) {
          break;
        }
        time += clocksOfTheDay[i + 1]
            .time
            .difference(clocksOfTheDay[i].time)
            .inSeconds;
      }
      spots += time.toInt();
    }
    return Duration(seconds: spots);
  }

  List<FlSpot> getClockedData() {
    List<FlSpot> spots = [];
    DateTime now = DateTime.now();
    List<ClockModel> clocks = fullClocks;
    clocks.sort(
      (a, b) {
        return a.time.compareTo(b.time);
      },
    );
    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(now.year, now.month, now.day - i);
      double time = 0;
      List clocksOfTheDay = clocks.where((element) {
        return element.time.day == day.day &&
            element.time.month == day.month &&
            element.time.year == day.year;
      }).toList();
      for (int i = 0; i < clocksOfTheDay.length; i += 2) {
        if (i + 1 >= clocksOfTheDay.length) {
          break;
        }
        time += clocksOfTheDay[i + 1]
            .time
            .difference(clocksOfTheDay[i].time)
            .inMinutes;
      }
      spots.add(FlSpot(i.toDouble(), (time ~/ 60).toDouble()));
    }
    return spots;
  }

  int nightTimeHours() {
    int night = 0;
    DateTime now = DateTime.now();
    List<ClockModel> clocks = fullClocks;
    clocks.sort(
      (a, b) {
        return a.time.compareTo(b.time);
      },
    );
    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(now.year, now.month, now.day - i);
      double time = 0;
      List clocksOfTheDay = clocks.where((element) {
        return element.time.day == day.day &&
            element.time.month == day.month &&
            element.time.year == day.year;
      }).toList();
      for (int i = 0; i < clocksOfTheDay.length; i += 2) {
        if (i + 1 >= clocksOfTheDay.length) {
          break;
        }
        if (clocksOfTheDay[i].time.hour <= 5 ||
            clocksOfTheDay[i].time.hour > 23) {
          time += clocksOfTheDay[i + 1]
              .time
              .difference(clocksOfTheDay[i].time)
              .inSeconds;
        }
      }
      night += time.toInt();
    }
    return night;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        //00h - 5h
        int fulltime = getTotalWorkingTime().inSeconds;
        int workedtime = getTotalClockTime().inSeconds;
        int missing = fulltime - workedtime;
        int night = nightTimeHours();
        int normal = workedtime - night;
        int overtime = workedtime - fulltime;
        missing = (missing < 0) ? 0 : missing;
        night = (night < 0) ? 0 : night;
        normal = (normal < 0) ? 0 : normal;
        overtime = (overtime < 0) ? 0 : overtime;
        int total = missing + night + normal + overtime;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color.fromRGBO(54, 162, 235, 1),
              value: normal / total * 100,
              title: "${total == 0 ? "0" : (normal / total * 100).toInt()}",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                shadows: shadows,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: const Color.fromRGBO(255, 99, 132, 1),
              value: overtime / total * 100,
              title: "${total == 0 ? "0" : (overtime / total * 100).toInt()}",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                shadows: shadows,
              ),
            );
          case 2:
            return PieChartSectionData(
              color: const Color.fromRGBO(75, 192, 192, 1),
              value: night / total * 100,
              title: "${total == 0 ? "0" : (night / total * 100).toInt()}",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                shadows: shadows,
              ),
            );
          case 3:
            return PieChartSectionData(
              color: const Color.fromRGBO(255, 206, 86, 1),
              value: missing / total * 100,
              title: "${total == 0 ? "0" : (missing / total * 100).toInt()}",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                shadows: shadows,
              ),
            );
          default:
            throw Error();
        }
      },
    );
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
              image: AssetImage("assets/logo.png"),
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
                color: Colors.black,
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
                                  color: Colors.black,
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
    List<Widget> widgets = [
      ...myEmployees
          .map((e) => ListTile(
                onTap: () {
                  setState(() {
                    selected = e.id;
                  });
                  getClocksAndWorking();
                  _scaffoldKey.currentState?.closeDrawer();
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.9),
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        title: const Image(
          image: AssetImage("assets/logo.png"),
          height: 50,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
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
            (fullClocks.length % 2 == 0),
            "Clock ${(fullClocks.length % 2 == 0) ? "in" : "out"} at ${DateFormat("yyyy-mm-dd hh:mm").format(DateTime.now())}",
          );
          getClocksAndWorking();
          setState(() {});
        },
        backgroundColor: Colors.white,
        child: Icon(
          (fullClocks.length % 2 == 0) ? Icons.timer : Icons.timer_off,
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
            RichText(
              text: TextSpan(
                text: (fullClocks.length % 2 != 0) ? "Working " : "Resting",
                style: TextStyle(
                  color: (fullClocks.length % 2 != 0)
                      ? Colors.green
                      : Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                children: (fullClocks.length % 2 != 0)
                    ? <TextSpan>[
                        TextSpan(
                          text:
                              ": ${totalWorkingTime.inHours < 10 ? "0" : ""}${totalWorkingTime.inHours}:${totalWorkingTime.inMinutes.remainder(60) < 10 ? "0" : ""}${totalWorkingTime.inMinutes.remainder(60)}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                          ),
                        ),
                        TextSpan(
                          text:
                              ":${totalWorkingTime.inSeconds.remainder(60) < 10 ? "0" : ""}${totalWorkingTime.inSeconds.remainder(60)}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ]
                    : [],
              ),
            ),
            SizedBox(
              height: 32,
              width: size.width,
            ),
            Text(
              DateFormat("EEEE dd MMMM yyyy").format(DateTime.now()),
              style: const TextStyle(
                color: Colors.black,
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
                      color: Colors.black.withOpacity(0.9),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    AspectRatio(
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
                            lineTouchData: const LineTouchData(enabled: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: getWorkingTimesData(),
                                isCurved: false,
                                curveSmoothness: 0.2,
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
                                isCurved: false,
                                curveSmoothness: 0.2,
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
                                  color: Colors.black,
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
                                  color: Colors.black,
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                      ),
                      Text(
                        "Time worked: ${getTotalClockTime().inHours}h${getTotalClockTime().inMinutes.remainder(60) < 10 ? "0" : ""}${getTotalClockTime().inMinutes.remainder(60)}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Supposed time to work: ${getTotalWorkingTime().inHours}h${getTotalWorkingTime().inMinutes.remainder(60) < 10 ? "0" : ""}${getTotalWorkingTime().inMinutes.remainder(60)}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (loadingPage == false && getTotalWorkingTime().inSeconds != 0)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.9),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.4,
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                height: 18,
                              ),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          setState(
                                            () {
                                              if (!event
                                                      .isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse
                                                          .touchedSection ==
                                                      null) {
                                                touchedIndex = -1;
                                                return;
                                              }
                                              touchedIndex = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            },
                                          );
                                        },
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: showingSections(),
                                    ),
                                  ),
                                ),
                              ),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Indicator(
                                    color: Color.fromRGBO(54, 162, 235, 1),
                                    text: 'Normal',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Color.fromRGBO(255, 99, 132, 1),
                                    text: 'Overtime',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Color.fromRGBO(75, 192, 192, 1),
                                    text: 'Nightime',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Color.fromRGBO(255, 206, 86, 1),
                                    text: 'Missing',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 28,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 100,
              width: size.width,
            ),
          ],
        ),
      ),
    );
  }
}
