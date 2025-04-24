import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/firebase_options.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/util/responsive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EduTrack Admin",
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
              ? HomeScreen(selectedIndex: 0, subScreen: null)
              : SelectableRegion(
                focusNode: FocusNode(),
                selectionControls: materialTextSelectionControls,
                child: HomeScreen(selectedIndex: 0),
              ),
    );
  }
}
