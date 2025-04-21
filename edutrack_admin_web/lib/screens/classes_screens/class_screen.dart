import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/class_info_data.dart';
import 'package:edutrack_admin_web/data/class_students_data.dart';
import 'package:edutrack_admin_web/models/class_students_model.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/inventory/inventory_element_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:flutter/material.dart';

class ClassScreen extends StatelessWidget {
  final String gradeNumber;
  final String classNumber;
  const ClassScreen({
    super.key,
    required this.gradeNumber,
    required this.classNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Class $gradeNumber/$classNumber"),
            SizedBox(height: Constants.internalSpacing),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        ClassInfoData().classInfoData
                            .map(
                              (stat) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: StatCardWidget(model: stat),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              child: FlexibleSmartTable<ClassStudentsTableModel>(
                title: "Class Students",
                columnNames: [
                  "Name",
                  "ID",
                  "Concentration",
                  "Number of Absences",
                  "Day Attendance",
                ],
                data: ClassStudentsData.classStudents,
                getValue: (row, column) {
                  switch (column) {
                    case "Name":
                      return row.name;
                    case "ID":
                      return row.id;
                    case "Concentration":
                      return row.concentration;
                    case "Day Attendance":
                      return row.attendance;
                    case "Number of Absences":
                      return row.absences.toString();
                    default:
                      return "";
                  }
                },
              ),
            ),
            SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              child: Column(
                children: [
                  Text(
                    "Inventory Management",
                    style: Constants.poppinsFont(
                      Constants.weightBold,
                      20,
                      Constants.primaryColor,
                    ),
                  ),
                  SizedBox(height: Constants.internalSpacing),
                  Row(
                    children: [
                      Spacer(),
                      InventoryElement(
                        inventoryTitle: "Marker",
                        inventoryStatus: "Available",
                      ),
                      Spacer(),
                      InventoryElement(
                        inventoryTitle: "Eraser",
                        inventoryStatus: "In Use",
                      ),
                      Spacer(),
                      InventoryElement(
                        inventoryTitle: "First Aid Kit",
                        inventoryStatus: "Missing",
                      ),
                      Spacer(),
                    ],
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
