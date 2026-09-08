import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management_system/screens/splash_screen.dart';
import 'package:library_management_system/screens/welcome_screen.dart';
import 'package:library_management_system/services/auth_service.dart';
import 'package:library_management_system/services/library_service.dart';

class LibraryManagementSystem extends StatelessWidget {
  const LibraryManagementSystem({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize global GetX services
    Get.put(AuthService());
    Get.put(LibraryService());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Management System',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        SplashScreen.name: (context) => const SplashScreen(),
        WelcomeScreen.name: (context) => const WelcomeScreen(),
      },
    );
  }
}
