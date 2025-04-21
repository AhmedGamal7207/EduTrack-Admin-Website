import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:flutter/material.dart';

class ReusableLongTextField extends StatelessWidget {
  final String headline;
  final String hintText;
  final TextEditingController? controller;

  const ReusableLongTextField({
    super.key,
    required this.headline,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(headline, style: Constants.lightTitle),
            Text("*", style: Constants.redLightTitle),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: null,
          minLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Constants.interFont(
              Constants.weightRegular,
              14,
              Constants.greyColor,
            ),
            filled: true,
            fillColor: Constants.whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Constants.greyBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Constants.greyBorder),
            ),
          ),
        ),
      ],
    );
  }
}
