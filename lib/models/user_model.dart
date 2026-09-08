enum UserRole { admin, librarian, student }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? studentId;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.studentId,
    this.profileImageUrl,
  });

  String get roleName {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.librarian:
        return 'Librarian';
      case UserRole.student:
        return 'Student / User';
    }
  }

  static UserRole roleFromString(String roleStr) {
    if (roleStr.contains('Admin')) return UserRole.admin;
    if (roleStr.contains('Librarian')) return UserRole.librarian;
    return UserRole.student;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.name,
        'studentId': studentId,
        'profileImageUrl': profileImageUrl,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: UserRole.values.firstWhere(
          (e) => e.name == json['role'],
          orElse: () => UserRole.student,
        ),
        studentId: json['studentId'],
        profileImageUrl: json['profileImageUrl'],
      );
}
