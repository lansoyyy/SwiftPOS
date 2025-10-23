import 'package:flutter/material.dart';
import 'package:para/screens/dashboard_screen.dart';

import 'package:para/screens/login_screen.dart';
import 'package:para/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftPOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'Regular',
      ),
      home: const LoginScreen(),
    );
  }
}
