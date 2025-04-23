import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/buttons/contact_button_widget.dart';

class FlexibleSmartTable<T> extends StatefulWidget {
  final String? title;
  final List<String> columnNames;
  final List<T> data;
  final String Function(T row, String columnName) getValue;
  final void Function(T row)? onRowTap;
  final double height;

  const FlexibleSmartTable({
    super.key,
    this.title,
    required this.columnNames,
    required this.data,
    required this.getValue,
    this.onRowTap,
    this.height = 325,
  });

  @override
  State<FlexibleSmartTable<T>> createState() => _FlexibleSmartTableState<T>();
}

class _FlexibleSmartTableState<T> extends State<FlexibleSmartTable<T>> {
  int? _hoveredRowIndex;

  @override
  Widget build(BuildContext context) {
    final defaultColumnWidths = {
      for (int i = 0; i < widget.columnNames.length; i++)
        i: const FlexColumnWidth(),
    };

    return SizedBox(
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Optional Title
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: Text(
                  widget.title!,
                  style: Constants.poppinsFont(
                    Constants.weightBold,
                    20,
                    Constants.primaryColor,
                  ),
                ),
              ),
            ),

          // Table
          Expanded(
            child: SingleChildScrollView(
              padding:
                  widget.title == null
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 0),
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    children:
                        widget.columnNames.map((col) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            child: Text(
                              col,
                              style: Constants.poppinsFont(
                                Constants.weightRegular,
                                16,
                                Constants.primaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  // Data rows
                  for (int i = 0; i < widget.data.length; i++)
                    _buildHoverableRow(widget.data[i], i),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildHoverableRow(T item, int rowIndex) {
    return TableRow(
      decoration: BoxDecoration(
        color:
            _hoveredRowIndex == rowIndex
                ? Constants.primaryColor.withOpacity(0.08)
                : Colors.transparent,
      ),
      children:
          widget.columnNames.map((col) {
            final content = widget.getValue(item, col);
            Widget cell;

            if (col.toLowerCase() == "name") {
              cell = Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Constants.primaryColor.withOpacity(0.2),
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
            } else if ((col.toLowerCase() == "contact parent" &&
                    content.contains("|")) ||
                (col.toLowerCase() == "contact teacher" &&
                    content.contains("|")) ||
                (col.toLowerCase() == "contact driver" &&
                    content.contains("|"))) {
              final parts = content.split("|");
              final phone = parts[0];
              final email = parts.length > 1 ? parts[1] : "";

              cell = Row(
                children: [
                  ContactButtonWidget(
                    icon: Icons.phone,
                    value: phone,
                    type: ContactType.phone,
                  ),
                  if (email.isNotEmpty)
                    ContactButtonWidget(
                      icon: Icons.email,
                      value: email,
                      type: ContactType.email,
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

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredRowIndex = rowIndex),
              onExit: (_) => setState(() => _hoveredRowIndex = null),
              cursor:
                  widget.onRowTap != null
                      ? SystemMouseCursors.click
                      : MouseCursor.defer,
              child: GestureDetector(
                onTap:
                    widget.onRowTap != null
                        ? () => widget.onRowTap!(item)
                        : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  color: Colors.transparent,
                  child: cell,
                ),
              ),
            );
          }).toList(),
    );
  }
}
