import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/side_menu_data.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        color: Constants.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/EduTrack Logo.png'),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  data.menu.length,
                  (index) => buildMenuEntry(data, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;
    return Container(
      //margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        color: isSelected ? Constants.menuSelectionColor : Colors.transparent,
      ),
      child: InkWell(
        onTap:
            () => setState(() {
              selectedIndex = index;
            }),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Image.asset(
                data.menu[index].icon,
                width: 24,
                height: 24,
                color: Constants.whiteColor,
              ),
            ),
            Text(
              data.menu[index].title,
              style: Constants.poppinsFont(
                Constants.poppinsLight,
                18,
                Constants.whiteColor,
                FontStyle.italic,
                18 * (9 / 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
