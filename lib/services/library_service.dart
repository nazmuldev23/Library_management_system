import 'package:get/get.dart';
import 'package:library_management_system/models/book.dart';
import 'package:library_management_system/models/borrow_record.dart';

class LibraryService extends GetxController {
  final RxList<Book> books = <Book>[].obs;
  final RxList<BorrowRecord> borrowRecords = <BorrowRecord>[].obs;
  final RxList<String> categories = <String>[
    'All',
    'Computer Science',
    'Fiction',
    'Science & Tech',
    'Mathematics',
    'History',
    'Biography'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    books.assignAll([
      Book(
        id: 'b1',
        title: 'Clean Code: A Handbook of Agile Software Craftsmanship',
        author: 'Robert C. Martin',
        isbn: '978-0132350884',
        category: 'Computer Science',
        description: 'Even bad code can function. But if code isn\'t clean, it can bring a development organization to its knees.',
        totalCopies: 5,
        availableCopies: 3,
        publisher: 'Prentice Hall',
        publishYear: 2008,
      ),
      Book(
        id: 'b2',
        title: 'Introduction to Algorithms',
        author: 'Thomas H. Cormen',
        isbn: '978-0262033848',
        category: 'Computer Science',
        description: 'A comprehensive update of the leading textbook on algorithms.',
        totalCopies: 4,
        availableCopies: 1,
        publisher: 'MIT Press',
        publishYear: 2009,
      ),
      Book(
        id: 'b3',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        isbn: '978-0061120084',
        category: 'Fiction',
        description: 'The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it.',
        totalCopies: 3,
        availableCopies: 2,
        publisher: 'Harper Perennial',
        publishYear: 1960,
      ),
      Book(
        id: 'b4',
        title: 'Sapiens: A Brief History of Humankind',
        author: 'Yuval Noah Harari',
        isbn: '978-0062316097',
        category: 'History',
        description: '100,000 years ago, at least six human species inhabited the earth. Today there is just one. Us. Homo sapiens.',
        totalCopies: 6,
        availableCopies: 4,
        publisher: 'Harper',
        publishYear: 2015,
      ),
      Book(
        id: 'b5',
        title: 'Flutter in Action',
        author: 'Eric Windmill',
        isbn: '978-1617296147',
        category: 'Computer Science',
        description: 'Teaches you to build beautiful multi-platform applications using Dart and Flutter.',
        totalCopies: 4,
        availableCopies: 4,
        publisher: 'Manning Publications',
        publishYear: 2020,
      ),
    ]);

    final now = DateTime.now();
    borrowRecords.assignAll([
      BorrowRecord(
        id: 'rec_1',
        bookId: 'b1',
        bookTitle: 'Clean Code: A Handbook of Agile Software Craftsmanship',
        userId: 'u_student',
        userName: 'John Doe',
        issueDate: now.subtract(const Duration(days: 10)),
        dueDate: now.add(const Duration(days: 4)),
        status: BorrowStatus.issued,
      ),
      BorrowRecord(
        id: 'rec_2',
        bookId: 'b2',
        bookTitle: 'Introduction to Algorithms',
        userId: 'u_student',
        userName: 'John Doe',
        issueDate: now.subtract(const Duration(days: 20)),
        dueDate: now.subtract(const Duration(days: 6)),
        status: BorrowStatus.overdue,
        fineAmount: 3.0,
      ),
    ]);
  }

  // Book CRUD operations
  void addBook(Book book) {
    books.add(book);
  }

  void updateBook(Book book) {
    final index = books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      books[index] = book;
    }
  }

  void deleteBook(String id) {
    books.removeWhere((b) => b.id == id);
  }

  // Borrowing logic
  bool requestOrBorrowBook(String bookId, String userId, String userName) {
    final bookIndex = books.indexWhere((b) => b.id == bookId);
    if (bookIndex == -1) return false;

    final book = books[bookIndex];
    if (book.availableCopies <= 0) return false;

    // Check if user already has an active borrow for this book
    final existingIndex = borrowRecords.indexWhere(
      (r) => r.bookId == bookId && r.userId == userId && (r.status == BorrowStatus.issued || r.status == BorrowStatus.requested || r.status == BorrowStatus.overdue),
    );
    if (existingIndex != -1) return false;

    books[bookIndex] = book.copyWith(
      availableCopies: book.availableCopies - 1,
    );

    final record = BorrowRecord(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      bookId: book.id,
      bookTitle: book.title,
      userId: userId,
      userName: userName,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: BorrowStatus.issued,
    );

    borrowRecords.add(record);
    return true;
  }

  bool returnBook(String recordId) {
    final recordIndex = borrowRecords.indexWhere((r) => r.id == recordId);
    if (recordIndex == -1) return false;

    final record = borrowRecords[recordIndex];
    if (record.status == BorrowStatus.returned) return false;

    borrowRecords[recordIndex] = record.copyWith(
      status: BorrowStatus.returned,
      returnDate: DateTime.now(),
    );

    final bookIndex = books.indexWhere((b) => b.id == record.bookId);
    if (bookIndex != -1) {
      final book = books[bookIndex];
      books[bookIndex] = book.copyWith(
        availableCopies: book.availableCopies + 1,
      );
    }

    return true;
  }

  // Analytics/Stats for Admin and Librarian
  int get totalBooks => books.fold(0, (sum, b) => sum + b.totalCopies);
  int get availableBooks => books.fold(0, (sum, b) => sum + b.availableCopies);
  int get activeLoans => borrowRecords.where((r) => r.status == BorrowStatus.issued || r.status == BorrowStatus.overdue).length;
  int get overdueLoans => borrowRecords.where((r) => r.isOverdue || r.status == BorrowStatus.overdue).length;
  double get totalFinesCollected => borrowRecords
      .where((r) => r.status == BorrowStatus.returned && r.fineAmount > 0)
      .fold(0.0, (sum, r) => sum + r.fineAmount);
  double get pendingFines => borrowRecords
      .where((r) => r.status != BorrowStatus.returned && (r.isOverdue || r.fineAmount > 0))
      .fold(0.0, (sum, r) => sum + (r.fineAmount > 0 ? r.fineAmount : 5.0));
}
