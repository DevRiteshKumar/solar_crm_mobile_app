import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/lead_pin_style.dart';
import '../../data/models/lead.dart';
import 'lead_quick_actions.dart';

class LeadListCard extends StatelessWidget {
  final int index;
  final Lead lead;
  final bool checkedIn;
  final VoidCallback? onMore;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onNavigate;
  final VoidCallback onCheckIn;
  final VoidCallback? onTap;
  final bool selected;
  final bool showIndex;
  final bool showNextStep;
  final bool showPhone;

  const LeadListCard({
    super.key,
    required this.index,
    required this.lead,
    required this.checkedIn,
    required this.onCall,
    required this.onWhatsApp,
    required this.onNavigate,
    required this.onCheckIn,
    this.onMore,
    this.onTap,
    this.selected = false,
    this.showIndex = true,
    this.showNextStep = true,
    this.showPhone = true,
  });

  @override
  Widget build(BuildContext context) {
    final pinColor = LeadPinStyle.colorFor(lead);
    final statusColor = _statusColor(lead.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: selected ? pinColor.withValues(alpha: 0.06) : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? pinColor.withValues(alpha: 0.45) : AppColors.border,
                width: selected ? 1.4 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: pinColor.withValues(alpha: selected ? 0.12 : 0.05),
                  blurRadius: selected ? 16 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: pinColor, width: 4)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LeadAvatar(
                        label: showIndex ? '$index' : _initials(lead.businessName),
                        color: pinColor,
                        checkedIn: checkedIn,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.businessName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              lead.customerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onMore != null)
                        InkWell(
                          onTap: onMore,
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.more_vert, size: 20, color: AppColors.textHint),
                          ),
                        ),
                    ],
                  ),
                  if (lead.address != null && lead.address!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: pinColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            lead.address!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (lead.lastContact != null && lead.lastContact!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.schedule_outlined, size: 14, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          'Last contact ${lead.lastContact}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (showPhone) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.call_outlined, size: 14, color: AppColors.phoneLink),
                        const SizedBox(width: 4),
                        Text(
                          lead.phone,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.phoneLink,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (showNextStep && lead.nextStep != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Next: ${lead.nextStep}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _InfoChip(
                        dotColor: statusColor,
                        label: lead.status,
                        background: statusColor.withValues(alpha: 0.10),
                        foreground: statusColor,
                      ),
                      _InfoChip(
                        icon: Icons.flag_rounded,
                        label: lead.priority,
                        background: pinColor.withValues(alpha: 0.10),
                        foreground: pinColor,
                      ),
                      if (lead.leadType.isNotEmpty)
                        _InfoChip(
                          icon: Icons.business_outlined,
                          label: lead.leadType,
                          background: AppColors.chipBg,
                          foreground: AppColors.textSecondary,
                        ),
                      if (lead.price != null)
                        _InfoChip(
                          icon: Icons.currency_rupee_rounded,
                          label: _formatPrice(lead.price!),
                          background: AppColors.primary.withValues(alpha: 0.08),
                          foreground: AppColors.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LeadQuickActions(
                    onCall: onCall,
                    onWhatsApp: onWhatsApp,
                    onNavigate: onNavigate,
                    onCheckIn: onCheckIn,
                    checkedIn: checkedIn,
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  static String _formatPrice(double price) {
    if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(price % 100000 == 0 ? 0 : 1)}L';
    }
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
    }
    return price.toStringAsFixed(0);
  }

  static Color _statusColor(String status) {
    final value = status.toLowerCase();
    if (value.contains('deal') || value.contains('confirm')) return AppColors.success;
    if (value.contains('qualified')) return AppColors.accentBlue;
    if (value.contains('quotation')) return AppColors.accentPurple;
    if (value.contains('interest')) return AppColors.accentOrange;
    return AppColors.textSecondary;
  }
}

class _LeadAvatar extends StatelessWidget {
  final String label;
  final Color color;
  final bool checkedIn;

  const _LeadAvatar({
    required this.label,
    required this.color,
    required this.checkedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withValues(alpha: 0.78),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.28),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (checkedIn)
          Positioned(
            right: -3,
            bottom: -3,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, size: 14, color: AppColors.success),
            ),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final Color? dotColor;
  final IconData? icon;

  const _InfoChip({
    required this.label,
    required this.background,
    required this.foreground,
    this.dotColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[
            Icon(icon, size: 11, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: foreground,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
