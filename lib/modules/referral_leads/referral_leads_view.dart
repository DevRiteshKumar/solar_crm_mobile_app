import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/lead_list_card.dart';
import '../../core/widgets/lead_summary_bar.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import 'referral_leads_controller.dart';

class ReferralLeadsView extends GetView<ReferralLeadsController> {
  const ReferralLeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(
            () => ProPageHeader(
              title: 'Referral Leads',
              subtitle: '${controller.leads.length} total',
              showBack: true,
              onSearch: controller.toggleSearch,
              onAdd: controller.addLead,
            ),
          ),
          Obx(() {
            if (!controller.showSearch.value) return const SizedBox.shrink();
            return ProSearchOverlay(
              hint: 'Search referral leads...',
              onChanged: controller.onSearch,
              onClose: () {
                controller.showSearch.value = false;
                controller.onSearch('');
              },
            );
          }),
          Obx(
            () => LeadSummaryBar(
              dueToday: controller.dueToday,
              needsAttention: controller.needsAttention,
              thisWeek: controller.thisWeek,
              totalLeads: controller.totalLeads,
              selectedFilter: controller.selectedFilter.value,
              customFilters: controller.customFilters,
              onFilterSelected: controller.selectFilter,
              onMore: controller.showFiltersSheet,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              if (controller.leads.isEmpty) {
                return const EmptyState(message: 'No referral leads found.');
              }
              return RefreshIndicator(
                onRefresh: controller.load,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  itemCount: controller.leads.length,
                  itemBuilder: (context, index) {
                    final lead = controller.leads[index];
                    return LeadListCard(
                      index: index + 1,
                      lead: lead,
                      showIndex: false,
                      showNextStep: false,
                      checkedIn: controller.isCheckedIn(lead.id),
                      onTap: () => controller.openLeadDetail(lead),
                      onUpdate: controller.patchLead,
                      onMore: () => controller.showLeadActions(lead),
                      onCall: () => controller.callLead(lead),
                      onNavigate: () => controller.navigateToLead(lead),
                      onEdit: () => controller.editLead(lead),
                      onClone: () => controller.cloneLead(lead),
                      onTasks: () => controller.openLeadItems(lead, 'Tasks'),
                      onNotes: () => controller.openLeadItems(lead, 'Notes'),
                      onFiles: () => controller.openLeadItems(lead, 'Files'),
                      onDelete: () => controller.confirmDelete(lead),
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
