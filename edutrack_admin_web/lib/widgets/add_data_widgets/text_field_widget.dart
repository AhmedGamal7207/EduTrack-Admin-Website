import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final String headline;
  final String hintText;
  final TextInputType inputType;
  final TextEditingController? controller;
  final bool isRequired;

  const ReusableTextField({
    super.key,
    required this.headline,
    required this.hintText,
    this.isRequired = true,
    this.inputType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !isRequired
            ? Text(headline, style: Constants.lightTitle)
            : Row(
              children: [
                Text(headline, style: Constants.lightTitle),
                Text("*", style: Constants.redLightTitle),
              ],
            ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: inputType,
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
              borderSide: BorderSide(color: Constants.fieldGreyBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Constants.fieldGreyBorder),
            ),
          ),
        ),
      ],
    );
  }
}
