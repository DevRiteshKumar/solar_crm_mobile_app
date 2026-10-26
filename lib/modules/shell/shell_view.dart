import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../contacts/contacts_view.dart';
import '../dashboard/dashboard_view.dart';
import '../leads/leads_view.dart';
import 'app_drawer.dart';
import 'shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      DashboardView(),
      LeadsView(),
      ContactsView(),
    ];

    return Obx(
      () => Scaffold(
        key: controller.scaffoldKey,
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: controller.currentIndex.value.clamp(0, 2),
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value.clamp(0, 2),
          onDestinationSelected: controller.changeTab,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.drawerActiveBg,
          elevation: 8,
          shadowColor: Colors.black12,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.gps_fixed_outlined),
              selectedIcon: Icon(Icons.gps_fixed, color: AppColors.primary),
              label: 'Leads',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people, color: AppColors.primary),
              label: 'Contacts',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu),
              selectedIcon: Icon(Icons.menu, color: AppColors.primary),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
