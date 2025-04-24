import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/all_drivers_model.dart';
import 'package:edutrack_admin_web/screens/buses_screens/add_driver_screen.dart';
import 'package:edutrack_admin_web/screens/buses_screens/driver_screen.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/services/driver_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/search_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BusesScreen extends StatefulWidget {
  const BusesScreen({super.key});

  @override
  State<BusesScreen> createState() => _BusesScreenState();
}

class _BusesScreenState extends State<BusesScreen> {
  TextEditingController searchController = TextEditingController();
  List<AllDriversTableModel> drivers = [];
  List<AllDriversTableModel> filteredDrivers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDrivers();
    searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredDrivers =
          drivers.where((driver) {
            return driver.name.toLowerCase().contains(query) ||
                driver.busNumber.toLowerCase().contains(query) ||
                driver.area.toLowerCase().contains(query);
          }).toList();
    });
  }

  Future<void> fetchDrivers() async {
    try {
      final driverDocs = await DriverService().getAllDrivers();
      final result =
          driverDocs
              .map(
                (data) => AllDriversTableModel(
                  name: data['driverName'] ?? '',
                  salary: data['salary'] ?? 0,
                  busNumber: data['busNumber'] ?? '',
                  area: data['area'] ?? '',
                  driverPhone: data['driverPhone'] ?? '',
                  driverMail: data['driverMail'] ?? '',
                ),
              )
              .toList();
      setState(() {
        drivers = result;
        filteredDrivers = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load drivers.";
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
            HeaderWidget(headerTitle: "Buses"),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ReusableSearchField(controller: searchController),
                  ),
                  Spacer(),
                  CustomButton(
                    text: "Add New Driver",
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => HomeScreen(
                                subScreen: AddDriverScreen(),
                                selectedIndex: 7,
                              ),
                        ),
                      );
                      if (result == true) fetchDrivers();
                    },
                    hasIcon: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: EdgeInsets.all(0),
              child:
                  isLoading
                      ? Center(
                        child: Lottie.asset(
                          Constants.tableLoadingPath,
                          height: 200,
                        ),
                      )
                      : errorMessage != null
                      ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                      : filteredDrivers.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("No drivers found."),
                      )
                      : FlexibleSmartTable<AllDriversTableModel>(
                        height: 500,
                        title: null,
                        columnNames: [
                          "Name",
                          "Salary",
                          "Bus Number",
                          "Area",
                          "Contact Driver",
                        ],
                        data: filteredDrivers,
                        onRowTap: (row) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => HomeScreen(
                                    subScreen: DriverScreen(
                                      name: row.name,
                                      phone: row.driverPhone,
                                    ),
                                    selectedIndex: 7,
                                  ),
                            ),
                          );
                        },
                        getValue: (row, column) {
                          switch (column) {
                            case "Name":
                              return row.name;
                            case "Salary":
                              return row.salary.toString();
                            case "Bus Number":
                              return row.busNumber;
                            case "Area":
                              return row.area;
                            case "Contact Driver":
                              return "${row.driverPhone}|${row.driverMail}";
                            default:
                              return "";
                          }
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
