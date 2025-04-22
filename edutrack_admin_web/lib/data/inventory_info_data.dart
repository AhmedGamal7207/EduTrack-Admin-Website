import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';

class InventoryInfoData {
  final inventoryInfoData = const [
    StatsModel(
      icon: 'assets/icons/inventory_icons/Marker.png',
      title: 'Missing Markers',
      value: "1",
      color: Constants.primaryColor,
    ),
    StatsModel(
      icon: 'assets/icons/inventory_icons/Eraser.png',
      title: 'Missing Erasers',
      value: "3",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/inventory_icons/First Aid.png',
      title: 'Missing First Aid Kits',
      value: "2",
      color: Constants.blueColor,
    ),
  ];
}
