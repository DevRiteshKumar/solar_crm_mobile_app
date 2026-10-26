import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/app_user.dart';
import '../user_repository.dart';

class MockUserRepository implements UserRepository {
  final List<AppUser> _users = List.from(MockData.users);

  @override
  Future<List<AppUser>> getUsers({String? query}) async {
    await Future.delayed(AppConstants.mockDelay);
    if (query == null || query.trim().isEmpty) return List.from(_users);
    final q = query.toLowerCase();
    return _users
        .where(
          (u) =>
              u.contactName.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q) ||
              u.role.toLowerCase().contains(q) ||
              u.contactNo.contains(q),
        )
        .toList();
  }

  @override
  Future<void> deleteUser(String id) async {
    await Future.delayed(AppConstants.mockDelay);
    _users.removeWhere((u) => u.id == id);
  }

  @override
  Future<void> resendLoginEmail(String id) async {
    await Future.delayed(AppConstants.mockDelay);
  }
}
