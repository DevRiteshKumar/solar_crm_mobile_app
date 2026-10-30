import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Professional page header: title + count + search/filter/+ actions
class ProPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onMenu;
  final VoidCallback? onSearch;
  final VoidCallback? onFilter;
  final VoidCallback? onAdd;
  final VoidCallback? onMap;
  final bool showBack;

  const ProPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onMenu,
    this.onSearch,
    this.onFilter,
    this.onAdd,
    this.onMap,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 12,
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onMenu != null || showBack)
            IconButton(
              icon: Icon(showBack ? Icons.arrow_back : Icons.menu, color: AppColors.textPrimary),
              onPressed: showBack ? () => Navigator.maybePop(context) : onMenu,
            )
          else
            const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OneLineTitle(
                  text: title,
                  style: AppTextStyles.heading2.copyWith(fontSize: 24, fontWeight: FontWeight.w800, height: 1.15),
                  minFontSize: 15,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
                  ),
              ],
            ),
          ),
          if (onSearch != null)
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textSecondary),
              onPressed: onSearch,
            ),
          if (onFilter != null)
            IconButton(
              icon: const Icon(Icons.tune, color: AppColors.textSecondary),
              onPressed: onFilter,
            ),
          if (onMap != null)
            IconButton(
              icon: const Icon(Icons.map_outlined, color: AppColors.textSecondary),
              onPressed: onMap,
            ),
          if (onAdd != null)
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
        ],
      ),
    );
  }
}

class OneLineTitle extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double minFontSize;

  const OneLineTitle({
    super.key,
    required this.text,
    required this.style,
    this.minFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (!maxWidth.isFinite || maxWidth <= 0) {
          return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
        }

        var fontSize = style.fontSize ?? 22;
        final min = minFontSize;
        while (fontSize > min) {
          final painter = TextPainter(
            text: TextSpan(text: text, style: style.copyWith(fontSize: fontSize, height: 1.15)),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: maxWidth);
          if (!painter.didExceedMaxLines && painter.width <= maxWidth) break;
          fontSize -= 1;
        }

        return Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style.copyWith(fontSize: fontSize, height: 1.15),
        );
      },
    );
  }
}

class ProStatCard {
  final IconData icon;
  final String value;
  final String label;

  const ProStatCard({required this.icon, required this.value, required this.label});
}

class ProStatsRow extends StatelessWidget {
  final List<ProStatCard> stats;

  const ProStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final s = stats[index];
          return Container(
            width: 118,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(s.icon, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      s.value,
                      style: AppTextStyles.heading3.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  s.label,
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProFilterChips extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  const ProFilterChips({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selected == filter;
          return GestureDetector(
            onTap: () => onSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(Icons.check, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    filter,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProSortFilterBar extends StatelessWidget {
  final String sortLabel;
  final VoidCallback? onSort;
  final VoidCallback? onFilters;

  const ProSortFilterBar({
    super.key,
    this.sortLabel = 'Last Contact',
    this.onSort,
    this.onFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          InkWell(
            onTap: onSort,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.sort, size: 16, color: AppColors.textHint),
                  const SizedBox(width: 6),
                  Text(
                    'Sort by: $sortLabel',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onFilters,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                children: [
                  Text(
                    'Filters',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.tune, size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProListCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const ProListCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: card,
    );
  }
}

class ProPriorityBadge extends StatelessWidget {
  final String label;

  const ProPriorityBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_outlined, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class ProStatusDotChip extends StatelessWidget {
  final String label;

  const ProStatusDotChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class ProSearchOverlay extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;
  final TextEditingController? controller;

  const ProSearchOverlay({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.onClose,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 12),
      child: TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
          filled: true,
          fillColor: AppColors.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}
