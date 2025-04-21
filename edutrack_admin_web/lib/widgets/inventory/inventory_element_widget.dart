import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/inventory/inventory_status_card.dart';
import 'package:flutter/material.dart';

class InventoryElement extends StatelessWidget {
  final String inventoryTitle;
  final String inventoryStatus;
  const InventoryElement({
    super.key,
    required this.inventoryTitle,
    required this.inventoryStatus,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (inventoryStatus) {
      case 'Available':
        bgColor = Constants.greenColor;
        break;
      case 'In Use':
        bgColor = Constants.greyColor;
        break;
      case 'Missing':
        bgColor = Constants.redColor;
        break;
      default:
        bgColor = Constants.greyColor;
    }
    return Column(
      children: [
        Image.asset("assets/images/$inventoryTitle.png"),
        Text(inventoryTitle, style: Constants.inventoryTitleStyle),
        InventoryStatusCard(text: inventoryStatus, bgColor: bgColor),
      ],
    );
  }
}
