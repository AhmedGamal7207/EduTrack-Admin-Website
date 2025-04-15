import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/main_screen.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Constants.bgColor,
        brightness: Brightness.light,
      ),
      home: const MainScreen(),
    );
  }
}
