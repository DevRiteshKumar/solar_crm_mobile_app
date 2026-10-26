import '../models/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getUsers({String? query});

  Future<void> deleteUser(String id);

  Future<void> resendLoginEmail(String id);
}
