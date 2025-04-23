import 'package:edutrack_admin_web/data/driver_data.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';

class DriverScreen extends StatelessWidget {
  final String name;
  final String phone;
  const DriverScreen({super.key, required this.name, required this.phone});

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
                        Text(name, style: Constants.mainHeadingStyle),
                        Text("Bus Driver", style: Constants.smallerLightTitle),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    DriverData().driverData1
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
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    DriverData().driverData2
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
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    DriverData().driverData3
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
                            ),
                          ],
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
