import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/clickable_card_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Classes"),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Wrap(
                  spacing: 50, // Horizontal space between cards
                  runSpacing: 20, // Vertical space between rows
                  alignment: WrapAlignment.center, // Center the whole row
                  children: List.generate(
                    12,
                    (index) => ClickableCard(
                      cardTitle: "Grade ${index + 1}",
                      buttonText: "Show Classes",
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
