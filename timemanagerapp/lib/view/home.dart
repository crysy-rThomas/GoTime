// ignore_for_file: use_build_context_synchronously

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:timemanagerapp/model/clock_model.dart';
import 'package:timemanagerapp/model/user_model.dart';
import 'package:timemanagerapp/service/authentification.dart';
import 'package:timemanagerapp/service/clock_service.dart';
import 'package:timemanagerapp/service/user_service.dart';
import 'package:timemanagerapp/utils/loading_screen.dart';
import 'package:timemanagerapp/utils/number_utils.dart';
import 'package:get/get.dart';
import 'package:timemanagerapp/utils/show_snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double maxheight = 15;
  List<UserModel> myEmployees = [];

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

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<ClockModel>>(
      future: ClockService().getMyClocks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const LoadingScreen();
        }
        List<ClockModel> clocks = snapshot.data!;
        return Scaffold(
          backgroundColor: Colors.black,
          drawer: Drawer(
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: myEmployees.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  title: Text(
                    "${myEmployees[index].firstname} ${myEmployees[index].lastname}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                  subtitle: Text(
                    "Role: ${myEmployees[index].role}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                );
              },
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () async {
                int? myId = int.tryParse(
                    await (const FlutterSecureStorage()).read(key: 'id') ??
                        "-1");
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
              child: Stack(
                children: [
                  const Image(
                    image: AssetImage("assets/clock.gif"),
                    height: 100,
                  ),
                  Positioned(
                    top: 30,
                    left: (clocks.length % 2 == 0) ? 60 : 50,
                    child: Text(
                      (clocks.length % 2 == 0) ? "Clock in" : "Clock out",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                  ),
                ],
              ),
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
                                spots: const [
                                  FlSpot(0, 7),
                                  FlSpot(1, 9),
                                  FlSpot(2, 4),
                                  FlSpot(3, 6),
                                  FlSpot(4, 7),
                                  FlSpot(5, 0),
                                  FlSpot(6, 0),
                                ],
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
                                spots: const [
                                  FlSpot(0, 9),
                                  FlSpot(1, 2),
                                  FlSpot(2, 7),
                                  FlSpot(3, 9),
                                  FlSpot(4, 2),
                                  FlSpot(5, 2),
                                  FlSpot(6, 2),
                                ],
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
                            // betweenBarsData: [
                            //   BetweenBarsData(
                            //     fromIndex: 0,
                            //     toIndex: 1,
                            //     color: Colors.red,
                            //   ),
                            // ],

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
