import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import 'users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(
            () => ProPageHeader(
              title: 'Users',
              subtitle: '${controller.users.length} total',
              showBack: true,
              onSearch: controller.toggleSearch,
              onAdd: () => Get.snackbar(
                'Add User',
                'Add user form coming soon',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
          ),
          Obx(() {
            if (!controller.showSearch.value) return const SizedBox.shrink();
            return ProSearchOverlay(
              hint: 'Search users...',
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
                  icon: Icons.group_outlined,
                  value: '${controller.users.length}',
                  label: 'Active users',
                ),
                const ProStatCard(
                  icon: Icons.admin_panel_settings_outlined,
                  value: '1',
                  label: 'Admins',
                ),
                const ProStatCard(
                  icon: Icons.badge_outlined,
                  value: '3',
                  label: 'Roles used',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => ProFilterChips(
              filters: const ['All', 'Admin', 'Sales'],
              selected: controller.selectedFilter.value,
              onSelected: controller.selectFilter,
            ),
          ),
          const SizedBox(height: 8),
          const ProSortFilterBar(sortLabel: 'Name'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              if (controller.users.isEmpty) return const EmptyState();
              return RefreshIndicator(
                onRefresh: () => controller.load(),
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final u = controller.users[index];
                    return ProListCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.drawerActiveBg,
                                child: Text(
                                  u.contactName.isNotEmpty ? u.contactName[0] : 'U',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.contactName,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      u.email,
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.showUserActions(u),
                                child: const Icon(Icons.more_vert, color: AppColors.textHint),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            u.contactNo,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.phoneLink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ProStatusDotChip(label: u.role),
                              if (u.address != null) ...[
                                const SizedBox(width: 10),
                                Text(
                                  u.address!,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
                                ),
                              ],
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
