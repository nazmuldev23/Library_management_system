import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management_system/models/user_model.dart';
import 'package:library_management_system/screens/welcome_screen.dart';
import 'package:library_management_system/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final user = authService.currentUser.value;
        if (user == null) {
          return const Center(child: Text('No user logged in'));
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.indigo.shade200),
                    ),
                    child: Text(
                      'Role: ${user.roleName}',
                      style: TextStyle(
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Account Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 1,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.indigo),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                  if (user.studentId != null) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.badge, color: Colors.indigo),
                      title: const Text('Student ID'),
                      subtitle: Text(user.studentId!),
                    ),
                  ],
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        const Icon(Icons.shield, color: Colors.indigo),
                    title: const Text('Role'),
                    subtitle: Text(user.roleName),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Switch Role (Demo mode)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 1,
              child: Column(
                children: UserRole.values.map((role) {
                  final isSelected = user.role == role;
                  return ListTile(
                    leading: Icon(
                      role == UserRole.admin
                          ? Icons.admin_panel_settings
                          : role == UserRole.librarian
                              ? Icons.menu_book
                              : Icons.school,
                      color: isSelected ? Colors.indigo : Colors.grey,
                    ),
                    title: Text(
                      role == UserRole.admin
                          ? 'Admin'
                          : role == UserRole.librarian
                              ? 'Librarian'
                              : 'Student / User',
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.indigo)
                        : null,
                    onTap: () {
                      authService.switchRole(role);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  authService.logout();
                  Get.offAll(() => const WelcomeScreen());
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        );
      }),
    );
  }
}
