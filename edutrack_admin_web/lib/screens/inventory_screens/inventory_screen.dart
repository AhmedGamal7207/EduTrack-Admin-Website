import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:edutrack_admin_web/services/inventory_service.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/inventory/inventory_element_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool isLoading = true;
  bool showMissingOnly = false;

  int numberOfMissingMarkers = 0;
  int numberOfMissingErasers = 0;
  int numberOfMissingKits = 0;

  List<StatsModel> groupedStats = [];
  List<Map<String, dynamic>> classInventoryList = [];

  @override
  void initState() {
    super.initState();
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    try {
      numberOfMissingMarkers =
          await InventoryService().getTotalMissingMarkers();
      numberOfMissingErasers =
          await InventoryService().getTotalMissingErasers();
      numberOfMissingKits = await InventoryService().getTotalMissingKits();

      final classes = await ClassService().getAllClasses();
      List<Map<String, dynamic>> tempClassInventoryList = [];

      for (var classDoc in classes) {
        String classId = classDoc['classId'] ?? '';
        String classNumber = classDoc['classNumber'].toString();
        String classLetter = classDoc['classLetter'] ?? '';
        String gradeNumber = classId.split('class')[0];

        String className = "Class $gradeNumber/$classNumber - $classLetter";

        final inventoryItems = await InventoryService().getInventoryByClassId(
          classId,
        );

        List<Map<String, dynamic>> items =
            inventoryItems.map((item) {
              return {
                'title': item['elementName'] ?? '-',
                'status': item['elementStatus'] ?? '-',
              };
            }).toList();

        tempClassInventoryList.add({
          'className': className,
          'gradeNumber': int.tryParse(gradeNumber) ?? 0,
          'classNumber': int.tryParse(classNumber) ?? 0,
          'items': items,
        });
      }

      // Sort classes by grade then class number
      tempClassInventoryList.sort((a, b) {
        int gradeComparison = a['gradeNumber'].compareTo(b['gradeNumber']);
        if (gradeComparison != 0) return gradeComparison;
        return a['classNumber'].compareTo(b['classNumber']);
      });

      setState(() {
        groupedStats = [
          StatsModel(
            icon: 'assets/icons/inventory_icons/Marker.png',
            title: 'Missing Markers',
            value: "$numberOfMissingMarkers",
            color: Constants.primaryColor,
          ),
          StatsModel(
            icon: 'assets/icons/inventory_icons/Eraser.png',
            title: 'Missing Erasers',
            value: "$numberOfMissingErasers",
            color: Constants.orangeColor,
          ),
          StatsModel(
            icon: 'assets/icons/inventory_icons/First Aid.png',
            title: 'Missing First Aid Kits',
            value: "$numberOfMissingKits",
            color: Constants.blueColor,
          ),
        ];
        classInventoryList = tempClassInventoryList;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching inventory elements: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(Constants.pagePadding),
        child: SingleChildScrollView(
          child:
              isLoading
                  ? Center(
                    child: Lottie.asset(
                      Constants.pageLoadingPath,
                      width: 450,
                      height: 450,
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderWidget(headerTitle: "Inventory"),
                      const SizedBox(height: Constants.internalSpacing),

                      // Stats Row
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  groupedStats
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
                      const SizedBox(height: Constants.internalSpacing),

                      // Inventory List
                      WhiteContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header + Toggle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Spacer(),
                                const SizedBox(width: 100),
                                Text(
                                  "Missing Inventory",
                                  style: Constants.poppinsFont(
                                    Constants.weightBold,
                                    20,
                                    Constants.primaryColor,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      "Missing Only",
                                      style: Constants.poppinsFont(
                                        Constants.weightMedium,
                                        14,
                                        Constants.primaryColor,
                                      ),
                                    ),
                                    Checkbox(
                                      value: showMissingOnly,
                                      activeColor: Constants.primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          showMissingOnly = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Classes List
                            ...classInventoryList.map((classItem) {
                              final className =
                                  classItem['className'] as String;
                              final items = classItem['items'] as List;

                              // Filter if "Missing Only" is checked
                              final filteredItems =
                                  showMissingOnly
                                      ? items
                                          .where(
                                            (item) =>
                                                item['status'] == 'Missing',
                                          )
                                          .toList()
                                      : items;

                              if (filteredItems.isEmpty)
                                return const SizedBox();

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      className,
                                      style: Constants.poppinsFont(
                                        Constants.weightBold,
                                        16,
                                        Constants.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children:
                                          filteredItems.map<Widget>((item) {
                                            return InventoryElement(
                                              inventoryTitle: item['title'],
                                              inventoryStatus: item['status'],
                                            );
                                          }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
