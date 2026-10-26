import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import 'roles_controller.dart';

class RolesView extends GetView<RolesController> {
  const RolesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(
            () => ProPageHeader(
              title: 'Roles',
              subtitle: '${controller.roles.length} total',
              showBack: true,
              onAdd: controller.addRole,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => ProStatsRow(
              stats: [
                ProStatCard(
                  icon: Icons.security_outlined,
                  value: '${controller.roles.length}',
                  label: 'Total roles',
                ),
                const ProStatCard(
                  icon: Icons.verified_user_outlined,
                  value: '6',
                  label: 'Active',
                ),
                const ProStatCard(
                  icon: Icons.add_moderator_outlined,
                  value: '2',
                  label: 'This month',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const ProSortFilterBar(sortLabel: 'Created date'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              if (controller.roles.isEmpty) return const EmptyState();
              return RefreshIndicator(
                onRefresh: controller.load,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: controller.roles.length,
                  itemBuilder: (context, index) {
                    final role = controller.roles[index];
                    return ProListCard(
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.drawerActiveBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.shield_outlined, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  role.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Created: ${controller.formatDate(role.createdAt)}',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: AppColors.textHint),
                            onSelected: (v) {
                              if (v == 'delete') controller.deleteRole(role.id);
                              if (v == 'edit') {
                                Get.snackbar('Edit', 'Edit role coming soon',
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(value: 'delete', child: Text('Delete')),
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
