import 'package:flutter/material.dart';
import 'package:sos_project_mobile/screens/android/login_screen.dart';

class SOSApp extends StatelessWidget {
  const SOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginScreen());
  }
}
