import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management_system/services/library_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryService = Get.find<LibraryService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    'Total Books',
                    '${libraryService.totalBooks}',
                    Icons.book,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Available Books',
                    '${libraryService.availableBooks}',
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Active Loans',
                    '${libraryService.activeLoans}',
                    Icons.sync_alt,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Overdue Books',
                    '${libraryService.overdueLoans}',
                    Icons.warning_amber_rounded,
                    Colors.red,
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'Quick Admin Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.people, color: Colors.white),
                    ),
                    title: const Text('Manage System Users & Roles'),
                    subtitle: const Text('View user accounts, change roles & permissions'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.snackbar('Admin Feature', 'Role permissions can be configured in user management.');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.analytics, color: Colors.white),
                    ),
                    title: const Text('Generate Circulation Reports'),
                    subtitle: const Text('Export borrowing logs and fine reports'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.snackbar('Report Generated', 'Circulation report exported successfully.');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.settings, color: Colors.white),
                    ),
                    title: const Text('System Settings & Fine Rates'),
                    subtitle: const Text('Configure borrowing rules, overdue charges'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.snackbar('Settings', 'Fine rate set to \$0.50 / day overdue.');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent System Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final recentRecords = libraryService.borrowRecords.reversed.take(5).toList();
              return Card(
                elevation: 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentRecords.length,
                  separatorBuilder: (ctx, idx) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final rec = recentRecords[index];
                    return ListTile(
                      leading: const Icon(Icons.history, color: Colors.indigo),
                      title: Text(rec.bookTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('User: ${rec.userName} • Status: ${rec.status.name}'),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Text(
                  value,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
