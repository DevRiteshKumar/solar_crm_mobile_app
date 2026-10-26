import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/role_model.dart';
import '../../data/repositories/role_repository.dart';

class RolesController extends GetxController {
  final RoleRepository _repository = Get.find();

  final isLoading = false.obs;
  final roles = <RoleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      roles.assignAll(await _repository.getRoles());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addRole() async {
    final nameController = TextEditingController();
    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Add New Role'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Role Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: nameController.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await _repository.createRole(result);
      await load();
      Get.snackbar('Created', 'Role added', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteRole(String id) async {
    await _repository.deleteRole(id);
    await load();
    Get.snackbar('Deleted', 'Role removed', snackPosition: SnackPosition.BOTTOM);
  }

  String formatDate(DateTime d) => DateFormat('dd MMM yyyy, hh:mm a').format(d);
}
