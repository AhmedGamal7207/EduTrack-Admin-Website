import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  final String cardTitle;
  final String buttonText;
  final VoidCallback onTap;
  const ClickableCard({
    super.key,
    required this.cardTitle,
    required this.buttonText,
    required this.onTap,
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
                CustomButton(onTap: onTap, text: buttonText),
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
