import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/inventory_info_data.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/inventory/inventory_element_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool showMissingOnly = false;

  final List<Map<String, dynamic>> classInventoryList = [
    {
      'className': 'Class 1/1 - London - A1',
      'items': [
        {'title': 'Marker', 'status': 'Available'},
        {'title': 'Eraser', 'status': 'Missing'},
        {'title': 'First Aid Kit', 'status': 'Available'},
      ],
    },
    {
      'className': 'Class 1/2 - Miami - A2',
      'items': [
        {'title': 'Marker', 'status': 'In Use'},
        {'title': 'Eraser', 'status': 'In Use'},
        {'title': 'First Aid Kit', 'status': 'Available'},
      ],
    },
    {
      'className': 'Class 1/3 - New York - A3',
      'items': [
        {'title': 'Marker', 'status': 'Missing'},
        {'title': 'Eraser', 'status': 'Missing'},
        {'title': 'First Aid Kit', 'status': 'Missing'},
      ],
    },
    {
      'className': 'Class 12/2 - Paris - D7',
      'items': [
        {'title': 'Eraser', 'status': 'Missing'},
        {'title': 'First Aid Kit', 'status': 'Missing'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(headerTitle: "Inventory"),
            const SizedBox(height: Constants.internalSpacing),

            // Stats Row
            Row(
              children:
                  InventoryInfoData().inventoryInfoData
                      .map(
                        (stat) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: StatCardWidget(model: stat),
                          ),
                        ),
                      )
                      .toList(),
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
                      Spacer(),
                      SizedBox(width: 100),
                      Text(
                        "Missing Inventory",
                        style: Constants.poppinsFont(
                          Constants.weightBold,
                          20,
                          Constants.primaryColor,
                        ),
                      ),
                      Spacer(),
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
                    final className = classItem['className'] as String;
                    final items = classItem['items'] as List;

                    // Filter if "Missing Only" is checked
                    final filteredItems =
                        showMissingOnly
                            ? items
                                .where((item) => item['status'] == 'Missing')
                                .toList()
                            : items;

                    if (filteredItems.isEmpty) return const SizedBox();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }
}
