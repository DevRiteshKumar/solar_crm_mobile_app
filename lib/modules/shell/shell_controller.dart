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

  /// Pages: 0 Home, 1 Leads, 2 Contacts, 3 Map
  /// Visual nav: Contacts, Leads, Home, Map, More
  int get navIndex {
    switch (currentIndex.value) {
      case 0:
        return 2; // Home
      case 1:
        return 1; // Leads
      case 2:
        return 0; // Contacts
      case 3:
        return 3; // Map
      default:
        return 2;
    }
  }

  void changeTab(int index) {
    switch (index) {
      case 0:
        showContacts();
        break;
      case 1:
        showLeads();
        break;
      case 2:
        showHome();
        break;
      case 3:
        showMap();
        break;
      case 4:
        scaffoldKey.currentState?.openDrawer();
        break;
    }
  }

  void showHome() => currentIndex.value = 0;

  void showLeads() {
    currentIndex.value = 1;
    openedRoute.value = AppRoutes.leads;
  }

  void showContacts() {
    currentIndex.value = 2;
    openedRoute.value = AppRoutes.contacts;
  }

  void showMap() {
    currentIndex.value = 3;
    openedRoute.value = AppRoutes.leadMap;
  }

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  void toggleLeadsMenu() => leadsExpanded.toggle();

  void toggleCustomFilters() => customFiltersExpanded.toggle();

  void toggleReferralLeads() => referralLeadsExpanded.toggle();

  void openLeads({String filter = 'All'}) {
    Get.back();
    showLeads();
    leadsExpanded.value = true;
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
        showHome();
        break;
      case AppRoutes.leads:
        showLeads();
        break;
      case AppRoutes.contacts:
        showContacts();
        break;
      case AppRoutes.leadMap:
        showMap();
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
