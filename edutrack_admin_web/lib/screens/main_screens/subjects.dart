import 'package:edutrack_admin_web/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(children: [HeaderWidget(headerTitle: "Subjects")]),
    );
  }
}
