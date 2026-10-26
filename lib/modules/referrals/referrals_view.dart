import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import 'referrals_controller.dart';

class ReferralsView extends GetView<ReferralsController> {
  const ReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(
            () => ProPageHeader(
              title: 'Referrals',
              subtitle: '${controller.referrals.length} total',
              showBack: true,
              onSearch: controller.toggleSearch,
              onAdd: () => Get.snackbar(
                'Add',
                'Add referral coming soon',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
          ),
          Obx(() {
            if (!controller.showSearch.value) return const SizedBox.shrink();
            return ProSearchOverlay(
              hint: 'Search referrals...',
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
                  icon: Icons.share_outlined,
                  value: '${controller.referrals.length}',
                  label: 'Total referrals',
                ),
                const ProStatCard(
                  icon: Icons.person_outline,
                  value: '2',
                  label: 'Owners',
                ),
                const ProStatCard(
                  icon: Icons.calendar_today_outlined,
                  value: '3',
                  label: 'This week',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => ProFilterChips(
              filters: const ['All', 'This Week', 'My Referrals'],
              selected: controller.selectedFilter.value,
              onSelected: (f) => controller.selectedFilter.value = f,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => ProSortFilterBar(
              sortLabel: controller.dateRangeLabel.value,
              onSort: () {},
              onFilters: () {},
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              if (controller.referrals.isEmpty) return const EmptyState();
              return RefreshIndicator(
                onRefresh: () => controller.load(),
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: controller.referrals.length,
                  itemBuilder: (context, index) {
                    final r = controller.referrals[index];
                    return ProListCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  r.businessName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Icon(Icons.more_vert, size: 20, color: AppColors.textHint),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            r.customerName,
                            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            r.contactNo,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.phoneLink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ProStatusDotChip(label: 'By ${r.referredBy}'),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Owner: ${r.leadOwner}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
