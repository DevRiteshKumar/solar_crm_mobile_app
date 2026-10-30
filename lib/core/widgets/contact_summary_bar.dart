import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ContactSummaryBar extends StatelessWidget {
  final int totalContacts;
  final int withCompany;
  final int withEmail;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const ContactSummaryBar({
    super.key,
    required this.totalContacts,
    required this.withCompany,
    required this.withEmail,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        children: [
          Row(
            children: [
              _StatTile(
                icon: Icons.people_alt_rounded,
                label: 'All Contacts',
                value: totalContacts,
                background: const Color(0xFFFFEBEE),
                foreground: const Color(0xFFC62828),
                onTap: () => onFilterSelected('All'),
              ),
              const SizedBox(width: 6),
              _StatTile(
                icon: Icons.business_rounded,
                label: 'With Company',
                value: withCompany,
                background: const Color(0xFFE3F2FD),
                foreground: const Color(0xFF1976D2),
                onTap: () => onFilterSelected('With Company'),
              ),
              const SizedBox(width: 6),
              _StatTile(
                icon: Icons.mail_rounded,
                label: 'With Email',
                value: withEmail,
                background: const Color(0xFFE8F5E9),
                foreground: const Color(0xFF2E7D32),
                onTap: () => onFilterSelected('With Email'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterPill(
                  label: 'All ($totalContacts)',
                  selected: selectedFilter == 'All',
                  leading: true,
                  onTap: () => onFilterSelected('All'),
                ),
                const SizedBox(width: 6),
                _FilterPill(
                  label: 'With Company ($withCompany)',
                  selected: selectedFilter == 'With Company',
                  onTap: () => onFilterSelected('With Company'),
                ),
                const SizedBox(width: 6),
                _FilterPill(
                  label: 'With Email ($withEmail)',
                  selected: selectedFilter == 'With Email',
                  onTap: () => onFilterSelected('With Email'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
                Icons.people_outline_rounded,
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
