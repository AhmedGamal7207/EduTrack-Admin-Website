import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/side_menu_data.dart';
import 'package:edutrack_admin_web/widgets/hoverable_menu_widget.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatelessWidget {
  final int selectedIndex;
  final double screenWidth;
  final ValueChanged<int> onItemTap;

  const SideMenuWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
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
              children: List.generate(data.menu.length, (index) {
                final isSelected = selectedIndex == index;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color:
                        isSelected
                            ? Constants.menuSelectionColor
                            : Colors.transparent,
                  ),
                  child: HoverableMenuItem(
                    onItemTap: onItemTap,
                    index: index,
                    childWidget: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          child: Image.asset(
                            data.menu[index].icon,
                            width: 24,
                            height: 24,
                            color: Constants.whiteColor,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            data.menu[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: Constants.poppinsFont(
                              Constants.poppinsLight,
                              getFontSize(screenWidth),
                              Constants.whiteColor,
                              FontStyle.italic,
                              18 * (9 / 100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  double getFontSize(width) {
    if (width >= 1500) return 18;
    if (width <= 1255) return 14;
    return 0.01633 * width - 6.51;
  }
}
