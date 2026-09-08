import 'package:get/get.dart';
import 'package:library_management_system/models/user_model.dart';

class AuthService extends GetxController {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  bool get isLoggedIn => currentUser.value != null;
  UserRole get currentRole => currentUser.value?.role ?? UserRole.student;

  final List<UserModel> mockUsers = [
    UserModel(
      id: 'u_admin',
      name: 'System Admin',
      email: 'admin@library.com',
      role: UserRole.admin,
    ),
    UserModel(
      id: 'u_librarian',
      name: 'Sarah Jenkins (Librarian)',
      email: 'librarian@library.com',
      role: UserRole.librarian,
    ),
    UserModel(
      id: 'u_student',
      name: 'John Doe',
      email: 'student@library.com',
      role: UserRole.student,
      studentId: 'ST-100234',
    ),
  ];

  Future<bool> login(String email, String password, UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = mockUsers.firstWhere(
      (u) => u.role == role,
      orElse: () => UserModel(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        role: role,
        studentId: role == UserRole.student ? 'ST-${DateTime.now().millisecondsSinceEpoch % 100000}' : null,
      ),
    );
    currentUser.value = user;
    return true;
  }

  void switchRole(UserRole role) {
    login('${role.name}@library.com', 'password', role);
  }

  void logout() {
    currentUser.value = null;
  }
}
