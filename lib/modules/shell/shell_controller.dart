import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/auth_user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../leads/leads_controller.dart';

class ShellController extends GetxController {
  final AuthRepository _authRepository = Get.find();

  final currentIndex = 0.obs;
  final AuthUser user = const AuthUser(
    id: '1',
    name: 'Shreesha Hegde',
    email: 'shreeshahegde@gmail.com',
    role: 'superadmin',
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final leadsExpanded = false.obs;
  final customFiltersExpanded = false.obs;

  void changeTab(int index) {
    if (index == 3) {
      scaffoldKey.currentState?.openDrawer();
      return;
    }
    currentIndex.value = index;
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  void toggleLeadsMenu() => leadsExpanded.toggle();

  void toggleCustomFilters() => customFiltersExpanded.toggle();

  void openLeads({String filter = 'All'}) {
    Get.back();
    currentIndex.value = 1;
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().selectFilter(filter);
    }
  }

  void navigateFromDrawer(String route) {
    Get.back(); // close drawer
    switch (route) {
      case AppRoutes.dashboard:
        currentIndex.value = 0;
        break;
      case AppRoutes.leads:
        currentIndex.value = 1;
        break;
      case AppRoutes.contacts:
        currentIndex.value = 2;
        break;
      default:
        Get.toNamed(route);
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
