import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String cardTitle;
  final String cardSubtitle;
  const InfoCard({
    super.key,
    required this.cardTitle,
    required this.cardSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 185,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Constants.clickableCardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cardTitle, style: Constants.cardTitleStyle),
                Spacer(),
                Text(cardSubtitle, style: Constants.cardTitleStyle),
              ],
            ),
          ),
        ),
        IgnorePointer(
          ignoring: true,
          child: Image.asset("assets/images/Card Graphics.png"),
        ),
      ],
    );
  }
}
