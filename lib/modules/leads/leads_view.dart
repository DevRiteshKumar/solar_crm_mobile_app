import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/lead_list_card.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import '../shell/shell_controller.dart';
import 'leads_controller.dart';

class LeadsView extends GetView<LeadsController> {
  const LeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(
            () => ProPageHeader(
              title: 'Leads',
              subtitle: '${controller.leads.length} total',
              onMenu: () => Get.find<ShellController>().openDrawer(),
              onSearch: controller.toggleSearch,
              onFilter: controller.showFiltersSheet,
              onMap: () => Get.toNamed(AppRoutes.leadMap),
              onAdd: () => Get.toNamed(AppRoutes.leadForm),
            ),
          ),
          Obx(() {
            if (!controller.showSearch.value) return const SizedBox.shrink();
            return ProSearchOverlay(
              hint: 'Search leads...',
              onChanged: controller.onSearch,
              onClose: () {
                controller.showSearch.value = false;
                controller.onSearch('');
              },
            );
          }),
          const SizedBox(height: 12),
          Obx(
            () => ProStatsRow(
              stats: [
                ProStatCard(
                  icon: Icons.calendar_today_outlined,
                  value: '${controller.dueToday}',
                  label: 'Due today',
                ),
                ProStatCard(
                  icon: Icons.flag_outlined,
                  value: '${controller.needsAttention}',
                  label: 'Needs attention',
                ),
                ProStatCard(
                  icon: Icons.person_add_alt_1_outlined,
                  value: '${controller.thisWeek}',
                  label: 'This week',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => ProFilterChips(
              filters: controller.filters.toList(),
              selected: controller.selectedFilter.value,
              onSelected: controller.selectFilter,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.customFilters.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'Custom Filters',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                ProFilterChips(
                  filters: controller.customFilters.toList(),
                  selected: controller.selectedFilter.value,
                  onSelected: controller.selectFilter,
                ),
              ],
            );
          }),
          const SizedBox(height: 8),
          Obx(
            () => ProSortFilterBar(
              sortLabel: controller.sortLabel.value,
              onSort: controller.showSortOptions,
              onFilters: controller.showFiltersSheet,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              if (controller.leads.isEmpty) return const EmptyState();
              return RefreshIndicator(
                onRefresh: controller.load,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: controller.leads.length,
                  itemBuilder: (context, index) {
                    final lead = controller.leads[index];
                    return LeadListCard(
                      index: index + 1,
                      lead: lead,
                      showIndex: false,
                      showNextStep: false,
                      showPhone: false,
                      checkedIn: controller.checkedInIds.contains(lead.id),
                      onMore: () => controller.showLeadActions(lead),
                      onCall: () => controller.callLead(lead),
                      onWhatsApp: () => controller.whatsappLead(lead),
                      onNavigate: () => controller.navigateToLead(lead),
                      onCheckIn: () => controller.checkInLead(lead),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
