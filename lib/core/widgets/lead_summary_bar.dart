import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class LeadSummaryBar extends StatelessWidget {
  final int dueToday;
  final int needsAttention;
  final int thisWeek;
  final int totalLeads;
  final String selectedFilter;
  final List<String> customFilters;
  final ValueChanged<String> onFilterSelected;
  final VoidCallback onMore;
  final EdgeInsetsGeometry padding;

  const LeadSummaryBar({
    super.key,
    required this.dueToday,
    required this.needsAttention,
    required this.thisWeek,
    required this.totalLeads,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onMore,
    this.customFilters = const [],
    this.padding = const EdgeInsets.fromLTRB(12, 8, 12, 4),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          Row(
            children: [
              _StatTile(
                icon: Icons.calendar_today_rounded,
                label: 'Due Today',
                value: dueToday,
                background: const Color(0xFFFFEBEE),
                foreground: const Color(0xFFC62828),
                onTap: () => onFilterSelected('Today'),
              ),
              const SizedBox(width: 6),
              _StatTile(
                icon: Icons.warning_amber_rounded,
                label: 'Needs Attention',
                value: needsAttention,
                background: const Color(0xFFFFF8E1),
                foreground: const Color(0xFFF9A825),
                onTap: () => onFilterSelected('High Priority'),
              ),
              const SizedBox(width: 6),
              _StatTile(
                icon: Icons.people_alt_rounded,
                label: 'This Week',
                value: thisWeek,
                background: const Color(0xFFE3F2FD),
                foreground: const Color(0xFF1976D2),
                onTap: () => onFilterSelected('All'),
              ),
              const SizedBox(width: 6),
              _StatTile(
                icon: Icons.bar_chart_rounded,
                label: 'Total Leads',
                value: totalLeads,
                background: const Color(0xFFE8F5E9),
                foreground: const Color(0xFF2E7D32),
                onTap: () => onFilterSelected('All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CustomFilterDropdown(
                  filters: customFilters,
                  selectedFilter: selectedFilter,
                  onSelected: onFilterSelected,
                ),
                const SizedBox(width: 6),
                _FilterPill(
                  label: 'All ($totalLeads)',
                  selected: selectedFilter == 'All' || selectedFilter == 'All Leads',
                  leading: true,
                  onTap: () => onFilterSelected('All'),
                ),
                const SizedBox(width: 6),
                _FilterPill(
                  label: 'Today ($dueToday)',
                  selected: selectedFilter == 'Today',
                  onTap: () => onFilterSelected('Today'),
                ),
                const SizedBox(width: 6),
                _FilterPill(
                  label: 'High Priority',
                  selected: selectedFilter == 'High Priority',
                  onTap: () => onFilterSelected('High Priority'),
                ),
                const SizedBox(width: 6),
                _FilterPill(
                  label: 'Interested',
                  selected: selectedFilter == 'Interested',
                  onTap: () => onFilterSelected('Interested'),
                ),
                const SizedBox(width: 6),
                _MorePill(onTap: onMore),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFilterDropdown extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const CustomFilterDropdown({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  bool get _customSelected => filters.contains(selectedFilter);

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();
    final selected = _customSelected;
    return GestureDetector(
      onTap: () => showCustomFilterPicker(
        context: context,
        filters: filters,
        selectedFilter: selectedFilter,
        onSelected: onSelected,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_rounded,
              size: 16,
              color: selected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 130),
              child: Text(
                selected ? selectedFilter : 'Custom Filters',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.expand_more,
              size: 16,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomFilterPicker({
  required BuildContext context,
  required List<String> filters,
  required String selectedFilter,
  required ValueChanged<String> onSelected,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    Icon(Icons.filter_alt_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Custom Filters',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.clear_all_rounded,
                        color: selectedFilter == 'All' ? AppColors.primary : AppColors.textSecondary,
                      ),
                      title: const Text('All Leads'),
                      trailing: selectedFilter == 'All' || selectedFilter == 'All Leads'
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () {
                        onSelected('All');
                        Navigator.pop(context);
                      },
                    ),
                    ...filters.map(
                      (filter) => ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.filter_alt_outlined,
                          color: selectedFilter == filter ? AppColors.primary : AppColors.textSecondary,
                        ),
                        title: Text(
                          filter,
                          style: TextStyle(
                            fontWeight: selectedFilter == filter ? FontWeight.w800 : FontWeight.w500,
                            color: selectedFilter == filter ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        trailing: selectedFilter == filter
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () {
                          onSelected(filter);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 8, 6, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 13, color: foreground),
                    const Spacer(),
                    Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        color: foreground,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 14, color: foreground.withValues(alpha: 0.7)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final bool leading;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading) ...[
              Icon(
                Icons.view_list_rounded,
                size: 14,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MorePill extends StatelessWidget {
  final VoidCallback onTap;

  const _MorePill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Icon(Icons.more_horiz, size: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
