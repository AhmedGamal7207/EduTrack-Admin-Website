import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const CustomCard({super.key, this.color, this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: color ?? Constants.whiteColor,
      ),
      child: Padding(padding: padding ?? EdgeInsets.all(12), child: child),
    );
  }
}
