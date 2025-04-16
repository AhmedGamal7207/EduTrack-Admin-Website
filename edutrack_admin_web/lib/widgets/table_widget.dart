import 'package:edutrack_admin_web/models/table_model.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';

class TableWidget extends StatelessWidget {
  final List<TableModel> data;

  const TableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Center(
            child: Text(
              "Attendance Warnings",
              style: Constants.poppinsFont(
                Constants.weightBold,
                20,
                Constants.primaryColor,
              ),
            ),
          ),
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(2),
          },
          border: const TableBorder(
            horizontalInside: BorderSide(color: Colors.grey, width: 0.3),
          ),
          children: [
            // Header Row
            TableRow(
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(0.1),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    "Name",
                    style: Constants.poppinsFont(
                      Constants.weightRegular,
                      18,
                      Constants.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    "ID",
                    style: Constants.poppinsFont(
                      Constants.weightRegular,
                      18,
                      Constants.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    "Grade",
                    style: Constants.poppinsFont(
                      Constants.weightRegular,
                      18,
                      Constants.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    "Class",
                    style: Constants.poppinsFont(
                      Constants.weightRegular,
                      18,
                      Constants.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    "Number of Absences",
                    style: Constants.poppinsFont(
                      Constants.weightRegular,
                      18,
                      Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Data Rows
            ...data.map(
              (entry) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Constants.primaryColor.withOpacity(
                            0.2,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.black54,
                          ),
                          // Optionally: use backgroundImage: NetworkImage(entry.avatarUrl)
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            entry.name,
                            overflow: TextOverflow.ellipsis,
                            style: Constants.poppinsFont(
                              Constants.weightLight,
                              18,
                              Constants.blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Text(
                      entry.id,
                      style: Constants.poppinsFont(
                        Constants.weightLight,
                        18,
                        Constants.blackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Text(
                      entry.grade,
                      style: Constants.poppinsFont(
                        Constants.weightLight,
                        18,
                        Constants.blackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Text(
                      entry.studentClass,
                      style: Constants.poppinsFont(
                        Constants.weightLight,
                        18,
                        Constants.blackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Text(
                      entry.absences.toString(),
                      style: Constants.poppinsFont(
                        Constants.weightLight,
                        18,
                        Constants.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
