import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management_system/models/borrow_record.dart';
import 'package:library_management_system/services/auth_service.dart';
import 'package:library_management_system/services/library_service.dart';
import 'package:library_management_system/widgets/book_detail_dialog.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final libraryService = Get.find<LibraryService>();
    final authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Library Portal'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Browse & Search'),
            Tab(icon: Icon(Icons.bookmark_outline), text: 'My Borrowed Books'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Browse & Search
          Obx(() {
            final query = searchController.text.toLowerCase().trim();
            final filteredBooks = libraryService.books.where((book) {
              final matchesCategory = selectedCategory == 'All' || book.category == selectedCategory;
              final matchesQuery = query.isEmpty ||
                  book.title.toLowerCase().contains(query) ||
                  book.author.toLowerCase().contains(query) ||
                  book.isbn.toLowerCase().contains(query);
              return matchesCategory && matchesQuery;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        onChanged: (val) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search by title, author, or ISBN...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: libraryService.categories.length,
                          separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = libraryService.categories[index];
                            final isSelected = selectedCategory == cat;
                            return ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: Colors.indigo,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredBooks.isEmpty
                      ? const Center(
                          child: Text(
                            'No books found.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Container(
                                  width: 45,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.book, color: Colors.indigo),
                                ),
                                title: Text(
                                  book.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${book.author} • ${book.category}'),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: book.isAvailable ? Colors.indigo : Colors.grey.shade400,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => BookDetailDialog(book: book),
                                    );
                                  },
                                  child: Text(book.isAvailable ? 'View' : 'Out of Stock'),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }),

          // Tab 2: My Borrowed Books
          Obx(() {
            final user = authService.currentUser.value;
            if (user == null) {
              return const Center(child: Text('Please log in'));
            }

            final myRecords = libraryService.borrowRecords.where((r) => r.userId == user.id).toList();

            if (myRecords.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'You have no borrowed books.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: myRecords.length,
              itemBuilder: (context, index) {
                final record = myRecords[index];
                final isOverdue = record.isOverdue;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                record.bookTitle,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: record.status == BorrowStatus.returned
                                    ? Colors.green.shade100
                                    : (isOverdue ? Colors.red.shade100 : Colors.blue.shade100),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                record.status == BorrowStatus.returned
                                    ? 'Returned'
                                    : (isOverdue ? 'Overdue' : 'Active'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: record.status == BorrowStatus.returned
                                      ? Colors.green.shade900
                                      : (isOverdue ? Colors.red.shade900 : Colors.blue.shade900),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Issue Date: ${_formatDate(record.issueDate)}', style: const TextStyle(fontSize: 13)),
                        Text('Due Date: ${_formatDate(record.dueDate)}', style: const TextStyle(fontSize: 13)),
                        if (record.returnDate != null)
                          Text('Return Date: ${_formatDate(record.returnDate!)}', style: const TextStyle(fontSize: 13)),
                        if (record.fineAmount > 0 || isOverdue) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Fine Amount: \$${record.fineAmount > 0 ? record.fineAmount.toStringAsFixed(2) : "5.00 (Pending Overdue)"}',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                        if (record.status != BorrowStatus.returned) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                final success = libraryService.returnBook(record.id);
                                if (success) {
                                  Get.snackbar('Success', 'Book returned successfully!');
                                }
                              },
                              icon: const Icon(Icons.assignment_return),
                              label: const Text('Return Book'),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
