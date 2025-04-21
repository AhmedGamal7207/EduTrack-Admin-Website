import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/remove_button_widget.dart';
import 'package:flutter/material.dart';

class ReusablePhotoUpload extends StatelessWidget {
  final String headline;
  final String imagePath;
  final VoidCallback onChoose;
  final VoidCallback onRemove;

  const ReusablePhotoUpload({
    super.key,
    required this.headline,
    required this.imagePath,
    required this.onChoose,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(headline, style: Constants.subHeadingStyle),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Constants.redColor)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Constants.greyColor,
            border: Border.all(color: Constants.fieldGreyBorder, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(imagePath),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CustomButton(text: "Choose File", onTap: () {}, hasIcon: false),
            const SizedBox(width: 10),
            RemoveButton(text: "Remove", onTap: () {}),
          ],
        ),
      ],
    );
  }
}
