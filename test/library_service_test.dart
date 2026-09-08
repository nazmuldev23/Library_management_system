import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:library_management_system/models/book.dart';
import 'package:library_management_system/models/user_model.dart';
import 'package:library_management_system/services/auth_service.dart';
import 'package:library_management_system/services/library_service.dart';

void main() {
  group('Library Management System Unit Tests', () {
    late LibraryService libraryService;
    late AuthService authService;

    setUp(() {
      Get.reset();
      authService = Get.put(AuthService());
      libraryService = Get.put(LibraryService());
    });

    test('Initial books and records load correctly', () {
      expect(libraryService.books.isNotEmpty, true);
      expect(libraryService.borrowRecords.isNotEmpty, true);
      expect(libraryService.totalBooks, greaterThan(0));
    });

    test('Add new book increases book list', () {
      final initialCount = libraryService.books.length;
      final newBook = Book(
        id: 'test_book_1',
        title: 'Test Book Title',
        author: 'Test Author',
        isbn: '123-456789',
        category: 'Fiction',
        description: 'Test description',
        totalCopies: 5,
        availableCopies: 5,
        publisher: 'Test Publisher',
        publishYear: 2023,
      );

      libraryService.addBook(newBook);
      expect(libraryService.books.length, initialCount + 1);
      expect(libraryService.books.any((b) => b.id == 'test_book_1'), true);
    });

    test('Borrow book decreases available copies and adds borrow record', () {
      final testBook = libraryService.books.firstWhere((b) => b.availableCopies > 0);
      final initialAvailable = testBook.availableCopies;
      final initialRecordsCount = libraryService.borrowRecords.length;

      final success = libraryService.requestOrBorrowBook(
        testBook.id,
        'u_test_user',
        'Test User',
      );

      expect(success, true);
      final updatedBook = libraryService.books.firstWhere((b) => b.id == testBook.id);
      expect(updatedBook.availableCopies, initialAvailable - 1);
      expect(libraryService.borrowRecords.length, initialRecordsCount + 1);
    });

    test('Cannot borrow same book twice concurrently', () {
      final testBook = libraryService.books.firstWhere((b) => b.availableCopies > 0);

      libraryService.requestOrBorrowBook(testBook.id, 'u_test_dup', 'Dup User');
      final secondAttempt = libraryService.requestOrBorrowBook(testBook.id, 'u_test_dup', 'Dup User');

      expect(secondAttempt, false);
    });

    test('Return book increases available copies and updates record status', () {
      final testBook = libraryService.books.firstWhere((b) => b.availableCopies > 0);
      libraryService.requestOrBorrowBook(testBook.id, 'u_test_returner', 'Returner User');

      final record = libraryService.borrowRecords.firstWhere(
        (r) => r.userId == 'u_test_returner' && r.bookId == testBook.id,
      );

      final bookBeforeReturn = libraryService.books.firstWhere((b) => b.id == testBook.id);
      final availableBeforeReturn = bookBeforeReturn.availableCopies;

      final returnSuccess = libraryService.returnBook(record.id);
      expect(returnSuccess, true);

      final bookAfterReturn = libraryService.books.firstWhere((b) => b.id == testBook.id);
      expect(bookAfterReturn.availableCopies, availableBeforeReturn + 1);
    });

    test('AuthService login and switch role', () async {
      expect(authService.isLoggedIn, false);

      await authService.login('admin@library.com', 'password', UserRole.admin);
      expect(authService.isLoggedIn, true);
      expect(authService.currentRole, UserRole.admin);

      authService.switchRole(UserRole.student);
      await Future.delayed(const Duration(milliseconds: 350));
      expect(authService.currentRole, UserRole.student);

      authService.logout();
      expect(authService.isLoggedIn, false);
    });
  });
}
