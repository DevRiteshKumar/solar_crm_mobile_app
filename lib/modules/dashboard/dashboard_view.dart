import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/lead_list_card.dart';
import '../../core/widgets/loading_view.dart';
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
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.load,
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    _WelcomeBanner(
                      greeting: controller.greeting(),
                      name: s.userName,
                      message: s.planExpiryMessage,
                      onExtend: controller.extendTrial,
                      onPackages: controller.allPackages,
                    ),
                    const SizedBox(height: 16),
                    _QuickActions(
                      onAddLead: controller.openAddLead,
                      onMap: () => Get.toNamed(AppRoutes.leadMap),
                      onContacts: () => Get.find<ShellController>().changeTab(2),
                      onTasks: () => Get.toNamed(AppRoutes.tasks),
                    ),
                    const SizedBox(height: 22),
                    const _SectionTitle(title: 'Overview'),
                    const SizedBox(height: 8),
                    _KpiGrid(
                      items: [
                        _KpiItem(
                          label: 'Total Leads',
                          value: '${s.totalLeads}',
                          icon: Icons.person_add_alt_1_rounded,
                          color: AppColors.primary,
                          subtitle: 'Active pipeline',
                          onTap: () => Get.find<ShellController>().changeTab(1),
                        ),
                        _KpiItem(
                          label: 'Contacts',
                          value: '${s.totalContacts}',
                          icon: Icons.people_alt_rounded,
                          color: AppColors.accentBlue,
                          subtitle: 'Saved people',
                          onTap: () => Get.find<ShellController>().changeTab(2),
                        ),
                        _KpiItem(
                          label: 'Referrals',
                          value: '${s.totalReferrers}',
                          icon: Icons.share_rounded,
                          color: AppColors.accentPurple,
                          subtitle: 'From network',
                          onTap: () => Get.toNamed(AppRoutes.referrals),
                        ),
                        _KpiItem(
                          label: 'Tasks',
                          value: '${s.totalTasks}',
                          icon: Icons.task_alt_rounded,
                          color: AppColors.accentOrange,
                          subtitle: 'To complete',
                          onTap: () => Get.toNamed(AppRoutes.tasks),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
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
                                'View all',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.arrow_forward_rounded, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final sectionLeads = controller.leadsForSection(s);
                      return Column(
                        children: [
                          _InsightTabs(
                            tabs: DashboardController.sectionTabs,
                            selected: controller.selectedSection.value,
                            onSelected: controller.selectSection,
                          ),
                          const SizedBox(height: 12),
                          _InsightCard(
                            title: controller.sectionTitle(),
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

  const _DashboardHeader({
    required this.dateLabel,
    required this.onMenu,
    required this.onRefresh,
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
                Text(
                  'Dashboard',
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B1F2A), Color(0xFF3A1D22), Color(0xFF8E2424)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
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
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      firstName,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.workspace_premium_outlined, size: 13, color: Color(0xFFFFD54F)),
                    SizedBox(width: 4),
                    Text(
                      'Trial',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_outlined, size: 16, color: Color(0xFFFFD54F)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onExtend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'Extend Trial',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onPackages,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'All Packages',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onAddLead;
  final VoidCallback onMap;
  final VoidCallback onContacts;
  final VoidCallback onTasks;

  const _QuickActions({
    required this.onAddLead,
    required this.onMap,
    required this.onContacts,
    required this.onTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _QuickAction(icon: Icons.add_rounded, label: 'Add Lead', color: AppColors.primary, onTap: onAddLead),
          _QuickAction(icon: Icons.map_outlined, label: 'Lead Map', color: AppColors.accentBlue, onTap: onMap),
          _QuickAction(icon: Icons.people_alt_outlined, label: 'Contacts', color: AppColors.accentPurple, onTap: onContacts),
          _QuickAction(icon: Icons.task_alt_outlined, label: 'Tasks', color: AppColors.accentOrange, onTap: onTasks),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
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
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 118,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
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
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon, size: 18, color: item.color),
                        ),
                        const Spacer(),
                        if (item.onTap != null)
                          Icon(Icons.north_east_rounded, size: 14, color: item.color.withValues(alpha: 0.7)),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textHint,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InsightTabs extends StatelessWidget {
  final List<String> tabs;
  final String selected;
  final ValueChanged<String> onSelected;

  const _InsightTabs({
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = selected == tab;
          return GestureDetector(
            onTap: () => onSelected(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
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
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800),
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
          ...leads.take(5).map((lead) {
            final leadsCtrl = Get.find<LeadsController>();
            return Obx(
              () => LeadListCard(
                index: 0,
                lead: lead,
                showIndex: false,
                showNextStep: false,
                showPhone: false,
                checkedIn: leadsCtrl.checkedInIds.contains(lead.id),
                onMore: () => leadsCtrl.showLeadActions(lead),
                onCall: () => leadsCtrl.callLead(lead),
                onWhatsApp: () => leadsCtrl.whatsappLead(lead),
                onNavigate: () => leadsCtrl.navigateToLead(lead),
                onCheckIn: () => leadsCtrl.checkInLead(lead),
              ),
            );
          }),
      ],
    );
  }
}

