import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';

class GradeSchedulePage extends StatefulWidget {
  final String gradeNumber;

  const GradeSchedulePage({super.key, required this.gradeNumber});

  @override
  State<GradeSchedulePage> createState() => _GradeSchedulePageState();
}

class _GradeSchedulePageState extends State<GradeSchedulePage> {
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
  final List<String> subjectOptions = ['Math', 'Science', 'English'];
  final List<String> teacherOptions = ['Mr. Smith', 'Ms. Johnson', 'Mr. Ali'];

  late List<List<Map<String, String>>> scheduleData;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    scheduleData = List.generate(
      7, // 7 rows for periods
      (_) => List.generate(
        5, // 5 days (Sun-Thu)
        (_) => {'subject': '', 'teacher': ''},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Constants.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              headerTitle:
                  'Grade ${widget.gradeNumber} Schedule${_isSaved ? " - Saved" : ""}',
            ),
            const SizedBox(height: Constants.internalSpacing),
            Expanded(
              child: WhiteContainer(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {0: FixedColumnWidth(100)},
                        children: [
                          // Header Row
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Constants.scheduleHeaderBg,
                            ),
                            children: [
                              const SizedBox(),
                              ...days.map(
                                (day) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: Constants.subHeadingStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Data Rows
                          for (int row = 0; row < scheduleData.length; row++)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'S${row + 1}',
                                      style: Constants.subHeadingStyle,
                                    ),
                                  ),
                                ),
                                ...List.generate(days.length, (col) {
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      children: [
                                        _buildDropdown(
                                          items: subjectOptions,
                                          hint: 'Subject',
                                          value:
                                              scheduleData[row][col]['subject'],
                                          onChanged: (value) {
                                            setState(() {
                                              scheduleData[row][col]['subject'] =
                                                  value!;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 6),
                                        _buildDropdown(
                                          items: teacherOptions,
                                          hint: 'Teacher',
                                          value:
                                              scheduleData[row][col]['teacher'],
                                          onChanged: (value) {
                                            setState(() {
                                              scheduleData[row][col]['teacher'] =
                                                  value!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (!_isSaved)
                        Align(
                          alignment: Alignment.center,
                          child: CustomButton(
                            text: "Save Schedule",
                            onTap: () {
                              setState(() {
                                _isSaved = true;
                              });
                            },
                            hasIcon: false,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal.shade100),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value!.isEmpty ? null : value,
          iconSize: _isSaved ? 0 : 20,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Constants.primaryColor,
          ),
          hint: Text(hint, style: const TextStyle(fontSize: 13)),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
          onChanged: _isSaved ? null : onChanged,
        ),
      ),
    );
  }
}
