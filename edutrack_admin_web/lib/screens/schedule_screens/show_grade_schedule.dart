import 'package:flutter/material.dart';

class ShowGradeSchedulePage extends StatelessWidget {
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
  final List<String> subjects = List.generate(
    7,
    (index) => 'Subject ${index + 1}',
  );

  final List<List<Map<String, String>>> schedule = List.generate(
    7,
    (_) => List.generate(5, (_) => {'subject': 'Math', 'teacher': 'Mr. Smith'}),
  );
  ShowGradeSchedulePage({super.key});

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
                const Icon(Icons.grid_view_rounded, color: Colors.teal),
                const SizedBox(width: 10),
                const Text(
                  'Grade 1 Schedule',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
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
                                  _infoBox(schedule[i][j]['subject']!),
                                  const SizedBox(height: 6),
                                  _infoBox(schedule[i][j]['teacher']!),
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
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 13))),
    );
  }
}
