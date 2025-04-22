import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/headers/profile_frame_widget.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/util/notifiers.dart';

class HeaderWidget extends StatelessWidget {
  final String headerTitle;
  const HeaderWidget({super.key, required this.headerTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            NavController.isMenuOpen.value = !NavController.isMenuOpen.value;
          },
          child: /*Image.asset(
            'assets/icons/Circled Menu.png',
            width: 50,
            height: 50,
            color: Constants.primaryColor,
          )*/ Icon(
            Icons.grid_view_rounded,
            color: Constants.primaryColor,
            size: 50,
          ),
        ),
        SizedBox(width: 20),
        Text(headerTitle, style: Constants.mainHeadingStyle),
        Expanded(child: SizedBox()),
        ProfileFrame(
          imageUrl:
              "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        ),
      ],
    );
  }
}
