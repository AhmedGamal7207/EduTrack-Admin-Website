import 'package:edutrack_admin_web/models/stats_model.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/services/driver_service.dart';
import 'package:lottie/lottie.dart';

class DriverScreen extends StatefulWidget {
  final String name;
  final String phone;
  const DriverScreen({super.key, required this.name, required this.phone});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool isLoading = true;
  List<List<StatsModel>> groupedStats = [];

  @override
  void initState() {
    super.initState();
    fetchDriverData();
  }

  Future<void> fetchDriverData() async {
    try {
      final drivers = await DriverService().getAllDrivers();
      final doc = drivers.firstWhere(
        (driver) => driver['driverPhone'] == widget.phone,
        orElse: () => {},
      );

      if (doc.isNotEmpty) {
        setState(() {
          groupedStats = [
            [
              StatsModel(
                icon: 'assets/icons/driver_icons/Salary.png',
                title: 'Salary',
                value: doc['salary'].toString(),
                color: Constants.orangeColor,
              ),
              StatsModel(
                icon: 'assets/icons/driver_icons/Phone.png',
                title: 'Driver Phone',
                value: doc['driverPhone'] ?? '-',
                color: Constants.orangeColor,
              ),
            ],
            [
              StatsModel(
                icon: 'assets/icons/driver_icons/School Bus.png',
                title: 'Bus Number',
                value: doc['busNumber'] ?? '-',
                color: Constants.orangeColor,
              ),
              StatsModel(
                icon: 'assets/icons/driver_icons/Area.png',
                title: 'Area',
                value: doc['area'] ?? '-',
                color: Constants.orangeColor,
              ),
            ],
            [
              StatsModel(
                icon: 'assets/icons/driver_icons/Mail.png',
                title: 'Driver Mail',
                value: doc['driverMail'] ?? '-',
                color: Constants.orangeColor,
              ),
              StatsModel(
                icon: 'assets/icons/driver_icons/Password.png',
                title: 'Driver Password',
                value: doc['driverPassword'] ?? '-',
                color: Constants.orangeColor,
              ),
            ],
          ];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(headerTitle: "Bus Driver Information"),
            SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none, // Important to allow overflow
                        children: [
                          // Teal container with rectangles
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 175,
                                  top: 70,
                                  child: Image.asset(
                                    'assets/images/Red Semi Circle.png',
                                  ),
                                ),
                                Positioned(
                                  right: 40,
                                  top: 32,
                                  child: Image.asset(
                                    'assets/images/Yellow Semi Circle.png',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Avatar with white border - moved up and placed outside
                          Positioned(
                            top: 90,
                            left: 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 58,
                                      backgroundImage: AssetImage(
                                        "assets/images/Driver.png",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name, style: Constants.mainHeadingStyle),
                        Text("Bus Driver", style: Constants.smallerLightTitle),
                        const SizedBox(height: 20),
                        isLoading
                            ? Lottie.asset(
                              Constants.statsLoadingPath,
                              height: 200,
                            )
                            : Column(
                              children:
                                  groupedStats
                                      .map(
                                        (pair) => Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children:
                                              pair
                                                  .map(
                                                    (stat) => Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                            ),
                                                        child: StatCardWidget(
                                                          model: stat,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      )
                                      .toList(),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
