import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/lead_list_card.dart';
import '../../core/widgets/lead_summary_bar.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import '../../data/models/lead.dart';
import '../leads/leads_controller.dart';
import '../shell/shell_controller.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value && controller.stats.value == null) {
          return const LoadingView(message: 'Loading dashboard...');
        }

        final s = controller.stats.value;
        if (s == null) {
          return Column(
            children: [
              _DashboardHeader(
                dateLabel: controller.dateRangeLabel.value,
                onMenu: () => Get.find<ShellController>().openDrawer(),
                onRefresh: controller.load,
                onAdd: controller.openAddLead,
              ),
              const Expanded(child: EmptyState(message: 'No dashboard data')),
            ],
          );
        }

        return Column(
          children: [
            _DashboardHeader(
              dateLabel: controller.dateRangeLabel.value,
              onMenu: () => Get.find<ShellController>().openDrawer(),
              onRefresh: controller.load,
              onAdd: controller.openAddLead,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.load,
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                  children: [
                    _WelcomeBanner(
                      greeting: controller.greeting(),
                      name: s.userName,
                      message: s.planExpiryMessage,
                      onExtend: controller.extendTrial,
                      onPackages: controller.allPackages,
                    ),
                    const SizedBox(height: 18),
                    Obx(() {
                      final leadsCtrl = Get.find<LeadsController>();
                      leadsCtrl.allLeads.length;
                      final selectedFilter = leadsCtrl.selectedFilter.value;
                      final source = leadsCtrl.allLeads.isNotEmpty
                          ? leadsCtrl.allLeads.toList()
                          : s.leadsByStatus;
                      final sectionLeads = leadsCtrl.applyFilter(source, selectedFilter);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionTitle(title: 'Overview'),
                          const SizedBox(height: 8),
                          _KpiGrid(
                            items: [
                              _KpiItem(
                                label: 'Due Today',
                                value: '${leadsCtrl.dueToday}',
                                subtitle: 'Visits scheduled',
                                icon: Icons.calendar_today_rounded,
                                color: AppColors.primary,
                                onTap: () => leadsCtrl.selectFilter('Today'),
                              ),
                              _KpiItem(
                                label: 'Needs Attention',
                                value: '${leadsCtrl.needsAttention}',
                                subtitle: 'High / interested',
                                icon: Icons.warning_amber_rounded,
                                color: AppColors.accentOrange,
                                onTap: () => leadsCtrl.selectFilter('High Priority'),
                              ),
                              _KpiItem(
                                label: 'This Week',
                                value: '${leadsCtrl.thisWeek}',
                                subtitle: 'Follow-ups',
                                icon: Icons.date_range_rounded,
                                color: AppColors.accentBlue,
                                onTap: () => leadsCtrl.selectFilter('All'),
                              ),
                              _KpiItem(
                                label: 'Total Leads',
                                value: '${leadsCtrl.totalLeads}',
                                subtitle: 'Full pipeline',
                                icon: Icons.bar_chart_rounded,
                                color: AppColors.success,
                                onTap: () => leadsCtrl.selectFilter('All'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Expanded(child: _SectionTitle(title: 'Lead Insights')),
                              TextButton(
                                onPressed: () => Get.find<ShellController>().changeTab(1),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'See All',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.arrow_forward_rounded, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LeadSummaryBar(
                            dueToday: leadsCtrl.dueToday,
                            needsAttention: leadsCtrl.needsAttention,
                            thisWeek: leadsCtrl.thisWeek,
                            totalLeads: leadsCtrl.totalLeads,
                            selectedFilter: selectedFilter,
                            customFilters: leadsCtrl.customFilters.toList(),
                            onFilterSelected: leadsCtrl.selectFilter,
                            onMore: leadsCtrl.showFiltersSheet,
                            padding: EdgeInsets.zero,
                            showStats: false,
                          ),
                          const SizedBox(height: 12),
                          _InsightCard(
                            title: selectedFilter == 'All' || selectedFilter == 'All Leads'
                                ? 'Leads'
                                : selectedFilter,
                            count: sectionLeads.length,
                            leads: sectionLeads,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        letterSpacing: -0.2,
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String dateLabel;
  final VoidCallback onMenu;
  final VoidCallback onRefresh;
  final VoidCallback onAdd;

  const _DashboardHeader({
    required this.dateLabel,
    required this.onMenu,
    required this.onRefresh,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.8))),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        left: 4,
        right: 8,
        bottom: 10,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
            onPressed: onMenu,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OneLineTitle(
                  text: 'Dashboard',
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    height: 1.15,
                  ),
                  minFontSize: 16,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.textSecondary),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          dateLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
          ),
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onAdd,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final String greeting;
  final String name;
  final String message;
  final VoidCallback onExtend;
  final VoidCallback onPackages;

  const _WelcomeBanner({
    required this.greeting,
    required this.name,
    required this.message,
    required this.onExtend,
    required this.onPackages,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = name.split(' ').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.tile,
              child: Text(
                firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    firstName,
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, size: 13, color: AppColors.success),
                  SizedBox(width: 4),
                  Text(
                    'Active',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Your plan is active',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Text(
                    message.replaceFirst(RegExp(r'^Your plan\s+', caseSensitive: false), ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accentOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: onExtend,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'Extend Plan',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: onPackages,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.ink,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'All Packages',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KpiItem {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _KpiItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

class _KpiGrid extends StatelessWidget {
  final List<_KpiItem> items;

  const _KpiGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 600 ? 4 : 2;
        const gap = 10.0;
        final itemWidth = (width - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map((item) => SizedBox(width: itemWidth, child: _KpiCard(item: item)))
              .toList(),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiItem item;

  const _KpiCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final iconSize = (36.0 * scale).clamp(32.0, 44.0);
    final valueSize = (22.0 * scale).clamp(18.0, 26.0);
    final labelSize = (12.0 * scale).clamp(11.0, 14.0);
    final subtitleSize = (10.0 * scale).clamp(9.0, 12.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: item.color, width: 4)),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: iconSize,
                        height: iconSize,
                        alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.tile,
                              borderRadius: BorderRadius.circular(11),
                            ),
                        child: Icon(item.icon, size: iconSize * 0.5, color: item.color),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.value,
                      maxLines: 1,
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: valueSize,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: labelSize,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: subtitleSize,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final int count;
  final List<Lead> leads;

  const _InsightCard({
    required this.title,
    required this.count,
    required this.leads,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.ink,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.drawerActiveBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (leads.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: EmptyState(message: 'No matching records found.'),
          )
        else
          ...leads.take(6).map((lead) {
            final leadsCtrl = Get.find<LeadsController>();
            return Obx(
              () => LeadListCard(
                index: 0,
                lead: lead,
                showIndex: false,
                showNextStep: false,
                checkedIn: leadsCtrl.checkedInIds.contains(lead.id),
                onTap: () => leadsCtrl.openLeadDetail(lead),
                onUpdate: leadsCtrl.patchLead,
                onMore: () => leadsCtrl.showLeadActions(lead),
                onCall: () => leadsCtrl.callLead(lead),
                onNavigate: () => leadsCtrl.navigateToLead(lead),
                onEdit: () => leadsCtrl.editLead(lead),
                onClone: () => leadsCtrl.cloneLead(lead),
                onTasks: () => leadsCtrl.openLeadItems(lead, 'Tasks'),
                onNotes: () => leadsCtrl.openLeadItems(lead, 'Notes'),
                onFiles: () => leadsCtrl.openLeadItems(lead, 'Files'),
                onDelete: () => leadsCtrl.confirmDelete(lead),
              ),
            );
          }),
      ],
    );
  }
}

