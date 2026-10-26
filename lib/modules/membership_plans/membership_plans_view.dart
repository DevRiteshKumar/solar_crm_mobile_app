import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import '../../data/models/membership_plan.dart';
import 'membership_plans_controller.dart';

class MembershipPlansView extends GetView<MembershipPlansController> {
  const MembershipPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(
            () => ProPageHeader(
              title: 'Membership Plans',
              subtitle: '${controller.plans.length} packages',
              showBack: true,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              if (controller.plans.isEmpty) return const EmptyState();
              return RefreshIndicator(
                onRefresh: controller.load,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  itemCount: controller.plans.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const _IntroBanner();
                    }
                    final plan = controller.plans[index - 1];
                    final isFeatured = index == 1;
                    final isSelected = controller.selectedPlanId.value == plan.id;
                    final expanded = controller.expandedPlanIds.contains(plan.id) || isFeatured;
                    return _PlanCard(
                      plan: plan,
                      priceLabel: currency.format(plan.pricePerMonth),
                      isFeatured: isFeatured,
                      isSelected: isSelected,
                      expanded: expanded,
                      onToggle: () => controller.toggleExpanded(plan.id),
                      onSelect: () => controller.selectPlan(plan),
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

class _IntroBanner extends StatelessWidget {
  const _IntroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.drawerActiveBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.workspace_premium_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a plan that fits your team',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Upgrade anytime. Billing is monthly.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final MembershipPlan plan;
  final String priceLabel;
  final bool isFeatured;
  final bool isSelected;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onSelect;

  const _PlanCard({
    required this.plan,
    required this.priceLabel,
    required this.isFeatured,
    required this.isSelected,
    required this.expanded,
    required this.onToggle,
    required this.onSelect,
  });

  String get _userNote {
    if (plan.restrictionNote != null) return plan.restrictionNote!;
    return 'Unlimited users';
  }

  List<String> get _visibleFeatures {
    if (expanded) return plan.features;
    return plan.features.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected || isFeatured
              ? AppColors.primary.withValues(alpha: 0.45)
              : AppColors.border,
          width: isSelected || isFeatured ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isFeatured ? AppColors.primary : Colors.black).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
              color: isFeatured || isSelected ? AppColors.primary : AppColors.border,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.name,
                          style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (isFeatured)
                        _Badge(label: 'Popular', color: AppColors.primary),
                      if (isSelected && !isFeatured)
                        _Badge(label: 'Selected', color: AppColors.accentOrange),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        priceLabel,
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '/ month',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.group_outlined, size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          _userNote,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Includes',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHint,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._visibleFeatures.map((f) {
                    final label = RegExp(r'^\d').hasMatch(f) || f.toLowerCase().startsWith('unlimited')
                        ? f
                        : 'Unlimited $f';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Row(
                        children: [
                          const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              label,
                              style: AppTextStyles.body.copyWith(height: 1.25),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (plan.features.length > 5)
                    TextButton(
                      onPressed: onToggle,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        expanded
                            ? 'Show less'
                            : '+ ${plan.features.length - 5} more features',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onSelect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.primaryDark : AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isSelected ? 'Current Plan' : 'Select Plan',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
