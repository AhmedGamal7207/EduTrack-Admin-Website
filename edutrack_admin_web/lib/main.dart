import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/util/responsive.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EduTrack Website",
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return child!;
          },
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Constants.bgColor,
        brightness: Brightness.light,
      ),
      home:
          Responsive.isMobile(context)
              ? HomeScreen(selectedIndex: 0)
              : SelectableRegion(
                focusNode: FocusNode(),
                selectionControls: materialTextSelectionControls,
                child: HomeScreen(selectedIndex: 0),
              ),
    );
  }
}
