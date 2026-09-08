import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management_system/models/book.dart';
import 'package:library_management_system/services/library_service.dart';

class LibrarianDashboardScreen extends StatefulWidget {
  const LibrarianDashboardScreen({super.key});

  @override
  State<LibrarianDashboardScreen> createState() => _LibrarianDashboardScreenState();
}

class _LibrarianDashboardScreenState extends State<LibrarianDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddEditBookDialog([Book? bookToEdit]) {
    final titleController = TextEditingController(text: bookToEdit?.title ?? '');
    final authorController = TextEditingController(text: bookToEdit?.author ?? '');
    final isbnController = TextEditingController(text: bookToEdit?.isbn ?? '');
    final categoryController = TextEditingController(text: bookToEdit?.category ?? 'Computer Science');
    final descController = TextEditingController(text: bookToEdit?.description ?? '');
    final copiesController = TextEditingController(text: bookToEdit?.totalCopies.toString() ?? '3');
    final publisherController = TextEditingController(text: bookToEdit?.publisher ?? 'Tech Publishing');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(bookToEdit == null ? 'Add New Book' : 'Edit Book'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: authorController, decoration: const InputDecoration(labelText: 'Author')),
              TextField(controller: isbnController, decoration: const InputDecoration(labelText: 'ISBN')),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: publisherController, decoration: const InputDecoration(labelText: 'Publisher')),
              TextField(
                controller: copiesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Copies'),
              ),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;
              final libraryService = Get.find<LibraryService>();
              final copies = int.tryParse(copiesController.text) ?? 1;

              if (bookToEdit == null) {
                final newBook = Book(
                  id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleController.text.trim(),
                  author: authorController.text.trim(),
                  isbn: isbnController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descController.text.trim(),
                  totalCopies: copies,
                  availableCopies: copies,
                  publisher: publisherController.text.trim(),
                  publishYear: DateTime.now().year,
                );
                libraryService.addBook(newBook);
                Get.snackbar('Added', 'New book added to library collection');
              } else {
                final updatedBook = bookToEdit.copyWith(
                  title: titleController.text.trim(),
                  author: authorController.text.trim(),
                  isbn: isbnController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descController.text.trim(),
                  totalCopies: copies,
                  publisher: publisherController.text.trim(),
                );
                libraryService.updateBook(updatedBook);
                Get.snackbar('Updated', 'Book details updated');
              }
              Navigator.pop(ctx);
            },
            child: Text(bookToEdit == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final libraryService = Get.find<LibraryService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Librarian Management Portal'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.library_books), text: 'Book Inventory'),
            Tab(icon: Icon(Icons.swap_horiz), text: 'Issue & Return Records'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => _showAddEditBookDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Book Inventory Management
          Obx(() {
            final books = libraryService.books;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Text('${book.availableCopies}', style: TextStyle(color: Colors.indigo.shade900, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Author: ${book.author} | Category: ${book.category}\nISBN: ${book.isbn}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => _showAddEditBookDialog(book),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            libraryService.deleteBook(book.id);
                            Get.snackbar('Deleted', 'Book removed from library');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),

          // Tab 2: Issue & Return Records
          Obx(() {
            final records = libraryService.borrowRecords;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final rec = records[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    title: Text(rec.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Borrower: ${rec.userName}\nIssued: ${_formatDate(rec.issueDate)} | Due: ${_formatDate(rec.dueDate)}'),
                    trailing: rec.status.name == 'returned'
                        ? const Chip(label: Text('Returned'), backgroundColor: Colors.greenAccent)
                        : ElevatedButton(
                            onPressed: () {
                              libraryService.returnBook(rec.id);
                              Get.snackbar('Success', 'Book return recorded');
                            },
                            child: const Text('Mark Returned'),
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
