import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/line_chart_data.dart';
import 'package:edutrack_admin_web/widgets/custom_card_widget.dart';
import 'package:edutrack_admin_web/widgets/header_widget.dart';
import 'package:edutrack_admin_web/widgets/line_chart_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Dashboard"),
            SizedBox(height: Constants.internalSpacing),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [Expanded(child: CustomCard(child: Text("Test")))],
            ),
            SizedBox(height: Constants.internalSpacing),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CustomCard(
                    child: LineChartCard(
                      graphTitle: "Students Attendance",
                      data: AttendanceLineData(),
                    ),
                  ),
                ),
                SizedBox(width: Constants.internalSpacing),
                Expanded(
                  child: CustomCard(
                    child: LineChartCard(
                      graphTitle: "Students Concentration",
                      data: ConcentrationLineData(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Constants.internalSpacing),
          ],
        ),
      ),
    );
  }
}
