import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/auth_user.dart';
import '../auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  AuthUser? _user;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    await Future.delayed(AppConstants.mockDelay);
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }
    _user = MockData.currentUser;
    return _user!;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await Future.delayed(AppConstants.mockDelay);
    if (email.trim().isEmpty) {
      throw Exception('Email is required');
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _user = null;
  }
}
