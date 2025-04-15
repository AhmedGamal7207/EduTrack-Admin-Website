import 'package:edutrack_admin_web/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(children: [HeaderWidget(headerTitle: "Students")]),
    );
  }
}
