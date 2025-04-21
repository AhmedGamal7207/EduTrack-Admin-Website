import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:flutter/material.dart';

class InventoryStatusCard extends StatelessWidget {
  final String text;
  final Color bgColor;

  const InventoryStatusCard({
    super.key,
    required this.text,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Constants.greyBorder, // Border color in hex format
          width: 1, // Border thickness
        ),
        color: bgColor,
      ),
      child: Center(
        child: Text(
          text,
          style:
              bgColor == Constants.greyColor
                  ? Constants.inventoryCardStyleBlack
                  : Constants.inventoryCardStyleWhite,
        ),
      ),
    );
  }
}
