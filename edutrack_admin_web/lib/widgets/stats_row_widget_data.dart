import 'package:edutrack_admin_web/data/stats_data.dart';
import 'package:edutrack_admin_web/widgets/stats_card_widget.dart';
import 'package:flutter/material.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = StatsData().statsData;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            stats
                .map(
                  (stat) =>
                      SizedBox(width: 200, child: StatCardWidget(model: stat)),
                )
                .toList(),
      ),
    );
  }
}
