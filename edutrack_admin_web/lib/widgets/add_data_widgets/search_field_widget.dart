import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';

class ReusableSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function(String)? onChanged;

  const ReusableSearchField({
    super.key,
    this.controller,
    this.hintText = "Search here...",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        hintText: hintText,
        hintStyle: Constants.interFont(
          Constants.weightRegular,
          14,
          Constants.greyColor,
        ),
        prefixIcon: const Icon(Icons.search, color: Constants.primaryColor),
        filled: true,
        fillColor: Constants.whiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Constants.fieldGreyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Constants.fieldGreyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Constants.primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
