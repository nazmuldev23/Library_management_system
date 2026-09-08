import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management_system/models/user_model.dart';
import 'package:library_management_system/screens/admin/admin_dashboard_screen.dart';
import 'package:library_management_system/screens/librarian/librarian_dashboard_screen.dart';
import 'package:library_management_system/screens/student/student_dashboard_screen.dart';

import 'package:library_management_system/screens/profile/profile_screen.dart';

import 'package:library_management_system/services/auth_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Obx(() {
      final user = authService.currentUser.value;
      final role = user?.role ?? UserRole.student;

      Widget mainDashboard;
      if (role == UserRole.admin) {
        mainDashboard = const AdminDashboardScreen();
      } else if (role == UserRole.librarian) {
        mainDashboard = const LibrarianDashboardScreen();
      } else {
        mainDashboard = const StudentDashboardScreen();
      }

      final pages = [
        mainDashboard,
        const ProfileScreen(),
      ];

      return Scaffold(
        body: pages[_selectedIndex.clamp(0, pages.length - 1)],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
