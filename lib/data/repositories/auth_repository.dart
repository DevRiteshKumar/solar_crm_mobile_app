import '../models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  Future<void> resetPassword({required String email});

  Future<AuthUser?> getCurrentUser();

  Future<void> logout();
}
