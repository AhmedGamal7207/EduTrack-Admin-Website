import 'package:edutrack_admin_web/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';

class StatCardWidget extends StatelessWidget {
  final StatsModel model;
  const StatCardWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: model.color,
            ),
            child: Center(
              child: Image.asset(
                model.icon,
                width: 30,
                height: 30,
                color: Constants.whiteColor,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.title,
                style: Constants.poppinsFont(
                  Constants.poppinsMedium,
                  14,
                  Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                model.value.toString(),
                style: Constants.poppinsFont(
                  Constants.poppinsBold,
                  26,
                  Constants.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
