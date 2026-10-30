import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/bubble_bottom_nav.dart';
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
        extendBody: true,
        backgroundColor: const Color(0xFFF7F8FA),
        bottomNavigationBar: BubbleBottomNav(
          currentIndex: controller.navIndex,
          onTap: controller.changeTab,
          items: const [
            BubbleNavItem(icon: Icons.gps_fixed, label: 'Leads'),
            BubbleNavItem(icon: Icons.people_rounded, label: 'Contacts'),
            BubbleNavItem(icon: Icons.dashboard_rounded, label: 'Home'),
            BubbleNavItem(icon: Icons.map_outlined, label: 'Map'),
            BubbleNavItem(icon: Icons.menu, label: 'More'),
          ],
        ),
      ),
    );
  }
}
