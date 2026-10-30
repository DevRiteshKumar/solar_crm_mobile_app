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
  final leadsExpanded = true.obs;
  final customFiltersExpanded = false.obs;
  final referralLeadsExpanded = false.obs;
  final openedRoute = ''.obs;

  /// Visual nav: Leads, Contacts, Home, Map, More
  int get navIndex {
    switch (currentIndex.value) {
      case 1:
        return 0;
      case 2:
        return 1;
      default:
        return 2;
    }
  }

  void changeTab(int index) {
    switch (index) {
      case 0:
        currentIndex.value = 1; // Leads
        break;
      case 1:
        currentIndex.value = 2; // Contacts
        break;
      case 2:
        currentIndex.value = 0; // Home / Dashboard
        break;
      case 3:
        Get.toNamed(AppRoutes.leadMap);
        break;
      case 4:
        scaffoldKey.currentState?.openDrawer();
        break;
    }
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  void toggleLeadsMenu() => leadsExpanded.toggle();

  void toggleCustomFilters() => customFiltersExpanded.toggle();

  void toggleReferralLeads() => referralLeadsExpanded.toggle();

  void openLeads({String filter = 'All'}) {
    Get.back();
    currentIndex.value = 1;
    leadsExpanded.value = true;
    openedRoute.value = AppRoutes.leads;
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().selectFilter(filter);
    }
  }

  void openReferralLeads() {
    Get.back();
    leadsExpanded.value = true;
    referralLeadsExpanded.value = true;
    openedRoute.value = AppRoutes.referralLeads;
    if (Get.currentRoute == AppRoutes.referralLeads) return;
    Get.toNamed(AppRoutes.referralLeads)?.then((_) {
      if (openedRoute.value == AppRoutes.referralLeads) {
        openedRoute.value = '';
      }
    });
  }

  void navigateFromDrawer(String route) {
    Get.back();
    openedRoute.value = route;
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
