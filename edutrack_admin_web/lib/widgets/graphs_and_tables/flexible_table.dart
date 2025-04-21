import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';

class FlexibleSmartTable<T> extends StatelessWidget {
  final String title;
  final List<String> columnNames;
  final List<T> data;

  /// A function that maps (row, columnName) → cell content
  final String Function(T row, String columnName) getValue;

  const FlexibleSmartTable({
    super.key,
    required this.title,
    required this.columnNames,
    required this.data,
    required this.getValue,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColumnWidths = {
      for (int i = 0; i < columnNames.length; i++) i: const FlexColumnWidth(),
    };

    return SizedBox(
      height: 325,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: Text(
                title,
                style: Constants.poppinsFont(
                  Constants.weightBold,
                  20,
                  Constants.primaryColor,
                ),
              ),
            ),
          ),
          // Table Body
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: defaultColumnWidths,
                border: const TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey, width: 0.3),
                ),
                children: [
                  // Header
                  TableRow(
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(0.1),
                    ),
                    children:
                        columnNames.map((col) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            child: Text(
                              col,
                              style: Constants.poppinsFont(
                                Constants.weightRegular,
                                18,
                                Constants.primaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  // Data
                  ...data.map((item) {
                    return TableRow(
                      children:
                          columnNames.map((col) {
                            final content = getValue(item, col);

                            Widget cell;

                            if (col.toLowerCase() == "name") {
                              cell = Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Constants.primaryColor
                                        .withOpacity(0.2),
                                    child: const Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      content,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.poppinsFont(
                                        Constants.weightLight,
                                        18,
                                        Constants.blackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              cell = Text(
                                content,
                                style: Constants.poppinsFont(
                                  Constants.weightLight,
                                  18,
                                  Constants.blackColor,
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: cell,
                            );
                          }).toList(),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
