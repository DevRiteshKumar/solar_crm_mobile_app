import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/role_model.dart';
import '../role_repository.dart';

class MockRoleRepository implements RoleRepository {
  final List<RoleModel> _roles = List.from(MockData.roles);

  @override
  Future<List<RoleModel>> getRoles() async {
    await Future.delayed(AppConstants.mockDelay);
    return List.from(_roles);
  }

  @override
  Future<RoleModel> createRole(String name) async {
    await Future.delayed(AppConstants.mockDelay);
    final role = RoleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: DateTime.now(),
    );
    _roles.insert(0, role);
    return role;
  }

  @override
  Future<void> deleteRole(String id) async {
    await Future.delayed(AppConstants.mockDelay);
    _roles.removeWhere((r) => r.id == id);
  }
}
