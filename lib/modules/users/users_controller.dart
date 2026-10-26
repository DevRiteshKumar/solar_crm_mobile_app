import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/app_user.dart';
import '../../data/repositories/user_repository.dart';

class UsersController extends GetxController {
  final UserRepository _repository = Get.find();

  final isLoading = false.obs;
  final users = <AppUser>[].obs;
  final showSearch = false.obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void toggleSearch() => showSearch.toggle();

  void selectFilter(String f) {
    selectedFilter.value = f;
    load();
  }

  Future<void> load({String? query}) async {
    try {
      isLoading.value = true;
      var list = await _repository.getUsers(query: query);
      if (selectedFilter.value == 'Admin') {
        list = list.where((u) => u.role.toLowerCase().contains('admin')).toList();
      } else if (selectedFilter.value == 'Sales') {
        list = list.where((u) => u.role.toLowerCase().contains('sales')).toList();
      }
      users.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String q) => load(query: q);

  Future<void> deleteUser(String id) async {
    await _repository.deleteUser(id);
    await load();
    Get.snackbar('Deleted', 'User removed', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> resendEmail(String id) async {
    await _repository.resendLoginEmail(id);
    Get.snackbar('Sent', 'Login email resent (mock)', snackPosition: SnackPosition.BOTTOM);
  }

  void showUserActions(AppUser user) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          color: Get.theme.cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF6A1B9A)),
                title: const Text('Edit'),
                onTap: () {
                  Get.back();
                  Get.snackbar('Edit', 'Edit user form coming soon', snackPosition: SnackPosition.BOTTOM);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Color(0xFFE53935)),
                title: const Text('Delete'),
                onTap: () {
                  Get.back();
                  deleteUser(user.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.mail_outline, color: Color(0xFFE53935)),
                title: const Text('Resend Login Email'),
                onTap: () {
                  Get.back();
                  resendEmail(user.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
