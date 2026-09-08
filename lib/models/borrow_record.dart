enum BorrowStatus { requested, issued, returned, overdue }

class BorrowRecord {
  final String id;
  final String bookId;
  final String bookTitle;
  final String userId;
  final String userName;
  final DateTime issueDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final BorrowStatus status;
  final double fineAmount;

  BorrowRecord({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.userId,
    required this.userName,
    required this.issueDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    this.fineAmount = 0.0,
  });

  bool get isOverdue {
    if (status == BorrowStatus.returned) return false;
    return DateTime.now().isAfter(dueDate);
  }

  BorrowRecord copyWith({
    String? id,
    String? bookId,
    String? bookTitle,
    String? userId,
    String? userName,
    DateTime? issueDate,
    DateTime? dueDate,
    DateTime? returnDate,
    BorrowStatus? status,
    double? fineAmount,
  }) {
    return BorrowRecord(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
      status: status ?? this.status,
      fineAmount: fineAmount ?? this.fineAmount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'bookTitle': bookTitle,
        'userId': userId,
        'userName': userName,
        'issueDate': issueDate.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
        'returnDate': returnDate?.toIso8601String(),
        'status': status.name,
        'fineAmount': fineAmount,
      };

  factory BorrowRecord.fromJson(Map<String, dynamic> json) => BorrowRecord(
        id: json['id'] ?? '',
        bookId: json['bookId'] ?? '',
        bookTitle: json['bookTitle'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        issueDate: DateTime.parse(json['issueDate']),
        dueDate: DateTime.parse(json['dueDate']),
        returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
        status: BorrowStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => BorrowStatus.issued,
        ),
        fineAmount: (json['fineAmount'] ?? 0.0).toDouble(),
      );
}
