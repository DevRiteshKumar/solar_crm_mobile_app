import '../models/role_model.dart';

abstract class RoleRepository {
  Future<List<RoleModel>> getRoles();

  Future<RoleModel> createRole(String name);

  Future<void> deleteRole(String id);
}
