import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/bubble_bottom_nav.dart';
import '../contacts/contacts_view.dart';
import '../dashboard/dashboard_view.dart';
import '../lead_map/lead_map_view.dart';
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
      LeadMapView(),
    ];

    return Obx(
      () => Scaffold(
        key: controller.scaffoldKey,
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: controller.currentIndex.value.clamp(0, 3),
          children: pages,
        ),
        extendBody: true,
        backgroundColor: const Color(0xFFF7F8FA),
        bottomNavigationBar: BubbleBottomNav(
          currentIndex: controller.navIndex,
          onTap: controller.changeTab,
          items: const [
            BubbleNavItem(
              icon: Icons.people_outline_rounded,
              activeIcon: Icons.people_rounded,
              label: 'Contacts',
            ),
            BubbleNavItem(
              icon: Icons.gps_fixed,
              activeIcon: Icons.my_location_rounded,
              label: 'Leads',
            ),
            BubbleNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
            ),
            BubbleNavItem(
              icon: Icons.map_outlined,
              activeIcon: Icons.map_rounded,
              label: 'Map',
            ),
            BubbleNavItem(
              icon: Icons.menu_rounded,
              activeIcon: Icons.menu_open_rounded,
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
