import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartCard extends StatefulWidget {
  final String graphTitle;
  final dynamic data;
  final bool showDateRow;

  const LineChartCard({
    super.key,
    required this.graphTitle,
    required this.data,
    this.showDateRow = false,
  });

  @override
  State<LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard> {
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();
    toDate = DateTime.now();
    fromDate = toDate.subtract(const Duration(days: 7));
  }

  Future<void> _selectDate({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d/M/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return WhiteContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(widget.graphTitle, style: Constants.subHeadingStyle),
          ),
          const SizedBox(height: 20),

          // Chart
          AspectRatio(
            aspectRatio: 16 / 7,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(handleBuiltInTouches: true),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return widget.data.bottomTitle[value.toInt()] != null
                            ? SideTitleWidget(
                              meta: meta,
                              child: Text(
                                widget.data.bottomTitle[value.toInt()]
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            )
                            : const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return widget.data.leftTitle[value.toInt()] != null
                            ? SideTitleWidget(
                              meta: meta,
                              child: Text(
                                widget.data.leftTitle[value.toInt()].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            )
                            : const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: Constants.primaryColor,
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Constants.primaryColor.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    dotData: FlDotData(show: false),
                    spots: widget.data.spots,
                  ),
                ],
                minX: 0,
                maxX: 120,
                maxY: 105,
                minY: -5,
              ),
            ),
          ),

          // Optional Date Row
          if (widget.showDateRow) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "From:",
                  style: Constants.poppinsFont(
                    Constants.weightMedium,
                    14,
                    Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                _buildDateChip(context, fromDate, (picked) {
                  setState(() => fromDate = picked);
                }),
                const SizedBox(width: 24),
                Text(
                  "To:",
                  style: Constants.poppinsFont(
                    Constants.weightMedium,
                    14,
                    Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                _buildDateChip(context, toDate, (picked) {
                  setState(() => toDate = picked);
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateChip(
    BuildContext context,
    DateTime date,
    ValueChanged<DateTime> onDateSelected,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap:
          () => _selectDate(
            context: context,
            initialDate: date,
            onDateSelected: onDateSelected,
          ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFD2EEF3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _formatDate(date),
          style: Constants.poppinsFont(
            Constants.weightMedium,
            13,
            Constants.primaryColor,
          ),
        ),
      ),
    );
  }
}
