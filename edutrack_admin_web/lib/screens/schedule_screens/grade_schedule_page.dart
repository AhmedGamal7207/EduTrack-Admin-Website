import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:flutter/material.dart';

class GradeSchedulePage extends StatelessWidget {
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
  final List<String> subjects = List.generate(
    7,
    (index) => 'Subject ${index + 1}',
  );
  final List<String> subjectOptions = ['Math', 'Science', 'English'];
  final List<String> teacherOptions = ['Mr. Smith', 'Ms. Johnson', 'Mr. Ali'];
  final String gradeNumber;
  GradeSchedulePage({super.key, required this.gradeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F5),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.grid_view_rounded,
                  color: Constants.primaryColor,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Grade 1 Schedule',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Constants.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Schedule Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  columnWidths: const {0: FixedColumnWidth(100)},
                  children: [
                    // Table Headers
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFE4F0F0)),
                      children: [
                        const SizedBox(),
                        ...days.map(
                          (day) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Schedule Rows
                    for (int i = 0; i < subjects.length; i++)
                      TableRow(
                        children: [
                          Container(
                            color: const Color(0xFFF2F8F8),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(subjects[i]),
                          ),
                          ...List.generate(days.length, (j) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  _buildDropdown(subjectOptions, "Subject"),
                                  const SizedBox(height: 6),
                                  _buildDropdown(teacherOptions, "Teacher"),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Save Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF239D9F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Save Schedule"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String hint) {
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
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.teal,
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
          onChanged: (value) {},
        ),
      ),
    );
  }
}
