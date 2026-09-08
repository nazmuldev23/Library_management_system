import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management_system/services/auth_service.dart';
import 'package:library_management_system/services/library_service.dart';

class BookDetailDialog extends StatelessWidget {
  final dynamic book;

  const BookDetailDialog({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final libraryService = Get.find<LibraryService>();
    final authService = Get.find<AuthService>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 95,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.book, size: 45, color: Colors.indigo.shade800),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'By ${book.author}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            book.category,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text('ISBN: ${book.isbn}', style: const TextStyle(fontSize: 13, color: Colors.black87)),
              Text('Publisher: ${book.publisher} (${book.publishYear})', style: const TextStyle(fontSize: 13, color: Colors.black87)),
              const SizedBox(height: 12),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                book.description,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Copies:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Chip(
                    label: Text('${book.availableCopies} / ${book.totalCopies}'),
                    backgroundColor: book.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                    labelStyle: TextStyle(
                      color: book.isAvailable ? Colors.green.shade900 : Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: book.isAvailable
                        ? () {
                            final user = authService.currentUser.value;
                            if (user != null) {
                              final success = libraryService.requestOrBorrowBook(
                                book.id,
                                user.id,
                                user.name,
                              );
                              Navigator.pop(context);
                              if (success) {
                                Get.snackbar('Success', 'Book borrowed successfully!');
                              } else {
                                Get.snackbar('Notice', 'You already have an active loan or request for this book.');
                              }
                            }
                          }
                        : null,
                    child: const Text('Borrow Book'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
