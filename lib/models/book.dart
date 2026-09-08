class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final String description;
  final int totalCopies;
  final int availableCopies;
  final String? coverUrl;
  final String publisher;
  final int publishYear;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.description,
    required this.totalCopies,
    required this.availableCopies,
    this.coverUrl,
    required this.publisher,
    required this.publishYear,
  });

  bool get isAvailable => availableCopies > 0;

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? isbn,
    String? category,
    String? description,
    int? totalCopies,
    int? availableCopies,
    String? coverUrl,
    String? publisher,
    int? publishYear,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      category: category ?? this.category,
      description: description ?? this.description,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
      coverUrl: coverUrl ?? this.coverUrl,
      publisher: publisher ?? this.publisher,
      publishYear: publishYear ?? this.publishYear,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'isbn': isbn,
        'category': category,
        'description': description,
        'totalCopies': totalCopies,
        'availableCopies': availableCopies,
        'coverUrl': coverUrl,
        'publisher': publisher,
        'publishYear': publishYear,
      };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        author: json['author'] ?? '',
        isbn: json['isbn'] ?? '',
        category: json['category'] ?? 'General',
        description: json['description'] ?? '',
        totalCopies: json['totalCopies'] ?? 1,
        availableCopies: json['availableCopies'] ?? 1,
        coverUrl: json['coverUrl'],
        publisher: json['publisher'] ?? '',
        publishYear: json['publishYear'] ?? DateTime.now().year,
      );
}
