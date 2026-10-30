import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/mock/mock_data.dart';
import '../leads/leads_controller.dart';
import 'shell_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShellController>();

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      AppConstants.logoPath,
                      height: 52,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.wb_sunny, color: AppColors.primary, size: 52),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text(
                      controller.user.name.isNotEmpty ? controller.user.name[0] : 'U',
                      style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.user.name, style: AppTextStyles.bodyMedium),
                        Text(controller.user.role, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _section('MAIN MENU'),
                  Obx(
                    () => _item(
                      icon: Icons.dashboard_outlined,
                      label: 'Dashboard',
                      route: AppRoutes.dashboard,
                      selected: controller.currentIndex.value == 0,
                      onTap: () => controller.navigateFromDrawer(AppRoutes.dashboard),
                    ),
                  ),
                  _section('CRM'),
                  Obx(() {
                    final leadsOpen = controller.leadsExpanded.value;
                    final customOpen = controller.customFiltersExpanded.value;
                    final referralOpen = controller.referralLeadsExpanded.value;
                    final onReferralLeads = controller.openedRoute.value == AppRoutes.referralLeads;
                    final onLeads = controller.currentIndex.value == 1 && !onReferralLeads;
                    final selectedFilter = Get.isRegistered<LeadsController>()
                        ? Get.find<LeadsController>().selectedFilter.value
                        : 'All';
                    final customFilters = Get.isRegistered<LeadsController>()
                        ? Get.find<LeadsController>().customFilters.toList()
                        : MockData.leadCustomFilters;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _item(
                          icon: Icons.gps_fixed,
                          label: 'Leads',
                          route: AppRoutes.leads,
                          selected: onLeads,
                          onTap: controller.toggleLeadsMenu,
                          trailing: Icon(
                            leadsOpen ? Icons.expand_less : Icons.expand_more,
                            size: 20,
                            color: onLeads ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                        if (leadsOpen) ...[
                          _nestedDotItem(
                            label: 'All Leads',
                            selected: onLeads && (selectedFilter == 'All' || selectedFilter == 'All Leads'),
                            onTap: () => controller.openLeads(filter: 'All'),
                          ),
                          _nestedDotItem(
                            label: 'Custom Filters',
                            selected: false,
                            onTap: controller.toggleCustomFilters,
                            trailing: Icon(
                              customOpen ? Icons.expand_less : Icons.expand_more,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (customOpen)
                            ...customFilters.map(
                              (filter) => _nestedDotItem(
                                label: filter,
                                depth: 2,
                                highlight: filter.toLowerCase().contains('very high') &&
                                    filter.toLowerCase() == 'very high priority',
                                selected: onLeads && selectedFilter == filter,
                                onTap: () => controller.openLeads(filter: filter),
                              ),
                            ),
                          _nestedDotItem(
                            label: 'Referrals',
                            selected: false,
                            onTap: controller.toggleReferralLeads,
                            trailing: Icon(
                              referralOpen ? Icons.expand_less : Icons.expand_more,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (referralOpen)
                            _nestedDotItem(
                              label: 'Referral Leads',
                              depth: 2,
                              selected: onReferralLeads,
                              onTap: controller.openReferralLeads,
                            ),
                        ],
                      ],
                    );
                  }),
                  _item(
                    icon: Icons.map_outlined,
                    label: 'Lead Map',
                    route: AppRoutes.leadMap,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.leadMap),
                  ),
                  _item(
                    icon: Icons.person_add_alt_1_outlined,
                    label: 'Referrals',
                    route: AppRoutes.referrals,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.referrals),
                  ),
                  Obx(
                    () => _item(
                      icon: Icons.person_outline,
                      label: 'Contacts',
                      route: AppRoutes.contacts,
                      selected: controller.currentIndex.value == 2,
                      onTap: () => controller.navigateFromDrawer(AppRoutes.contacts),
                    ),
                  ),
                  _item(
                    icon: Icons.request_quote_outlined,
                    label: 'Quotation',
                    route: AppRoutes.quotation,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.quotation),
                  ),
                  _item(
                    icon: Icons.receipt_long_outlined,
                    label: 'Invoice',
                    route: AppRoutes.invoice,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.invoice),
                  ),
                  _item(
                    icon: Icons.description_outlined,
                    label: 'Proforma Invoice',
                    route: AppRoutes.proformaInvoice,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.proformaInvoice),
                  ),
                  _item(
                    icon: Icons.article_outlined,
                    label: 'Proposal',
                    route: AppRoutes.proposal,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.proposal),
                  ),
                  _item(
                    icon: Icons.checklist_outlined,
                    label: 'Tasks',
                    route: AppRoutes.tasks,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.tasks),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                  ),
                  _item(
                    icon: Icons.inventory_2_outlined,
                    label: 'Products',
                    route: AppRoutes.products,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.products),
                  ),
                  _item(
                    icon: Icons.price_change_outlined,
                    label: 'Products Pricing Inquiry',
                    route: AppRoutes.productsPricing,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.productsPricing),
                    highlight: true,
                  ),
                  _item(
                    icon: Icons.storefront_outlined,
                    label: 'Vendor Management',
                    route: AppRoutes.vendorManagement,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.vendorManagement),
                  ),
                  _item(
                    icon: Icons.report_problem_outlined,
                    label: 'Complaints',
                    route: AppRoutes.complaints,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.complaints),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                  ),
                  _item(
                    icon: Icons.business_outlined,
                    label: 'Clients',
                    route: AppRoutes.clients,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.clients),
                  ),
                  _item(
                    icon: Icons.settings_outlined,
                    label: 'CRM Settings',
                    route: AppRoutes.crmSettings,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.crmSettings),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                  ),
                  _item(
                    icon: Icons.tune_outlined,
                    label: 'Pre Set',
                    route: AppRoutes.preSet,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.preSet),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                  ),
                  _section('USER MANAGEMENT'),
                  _item(
                    icon: Icons.group_outlined,
                    label: 'Manage Users',
                    route: AppRoutes.users,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.users),
                  ),
                  _item(
                    icon: Icons.security_outlined,
                    label: 'Roles & Permissions',
                    route: AppRoutes.roles,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.roles),
                  ),
                  _item(
                    icon: Icons.card_membership_outlined,
                    label: 'Membership Plans',
                    route: AppRoutes.membershipPlans,
                    onTap: () => controller.navigateFromDrawer(AppRoutes.membershipPlans),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: Text(
                'Logout',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
              ),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(title, style: AppTextStyles.sectionHeader),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required String route,
    required VoidCallback onTap,
    bool selected = false,
    bool highlight = false,
    Widget? trailing,
  }) {
    final color = selected || highlight ? AppColors.primary : AppColors.textPrimary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: selected ? AppColors.drawerActiveBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: selected
            ? const Border(left: BorderSide(color: AppColors.primary, width: 3))
            : null,
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 20, color: color),
        title: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: selected || highlight ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _nestedDotItem({
    required String label,
    required VoidCallback onTap,
    bool selected = false,
    bool highlight = false,
    int depth = 1,
    Widget? trailing,
  }) {
    final color = selected || highlight ? AppColors.primary : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(depth == 1 ? 48 : 64, 8, 12, 8),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: selected || highlight ? AppColors.primary : AppColors.textHint,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: selected || highlight ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
