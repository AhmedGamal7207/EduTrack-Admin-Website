import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:flutter/material.dart';

class ReusableComboBox<T> extends StatelessWidget {
  final String headline;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;

  const ReusableComboBox({
    super.key,
    required this.headline,
    required this.items,
    required this.itemLabel,
    this.selectedItem,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headline, style: Constants.lightTitle),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: selectedItem,
          items:
              items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
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
