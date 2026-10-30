import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/lead_pin_style.dart';
import '../../data/models/lead.dart';
import 'lead_field_dropdowns.dart';
import 'lead_quick_actions.dart';

class LeadListCard extends StatelessWidget {
  final int index;
  final Lead lead;
  final bool checkedIn;
  final VoidCallback? onMore;
  final VoidCallback onCall;
  final VoidCallback onNavigate;
  final VoidCallback onEdit;
  final VoidCallback onClone;
  final VoidCallback onTasks;
  final VoidCallback onNotes;
  final VoidCallback onFiles;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final ValueChanged<Lead>? onUpdate;
  final bool selected;
  final bool showIndex;
  final bool showNextStep;

  const LeadListCard({
    super.key,
    required this.index,
    required this.lead,
    required this.checkedIn,
    required this.onCall,
    required this.onNavigate,
    required this.onEdit,
    required this.onClone,
    required this.onTasks,
    required this.onNotes,
    required this.onFiles,
    required this.onDelete,
    this.onMore,
    this.onTap,
    this.onUpdate,
    this.selected = false,
    this.showIndex = true,
    this.showNextStep = true,
  });

  @override
  Widget build(BuildContext context) {
    final pinColor = LeadPinStyle.colorFor(lead);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? pinColor.withValues(alpha: 0.45) : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: pinColor, width: 5)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.businessName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 1),
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
                  const SizedBox(height: 6),
                  _MetaRow(
                    icon: Icons.call_outlined,
                    text: lead.displayPhone,
                    color: AppColors.phoneLink,
                  ),
                  _MetaRow(
                    icon: Icons.mail_outline_rounded,
                    text: lead.displayEmail,
                    color: AppColors.textSecondary,
                  ),
                  _MetaRow(
                    icon: Icons.location_on_outlined,
                    text: lead.displayAddress,
                    color: pinColor,
                  ),
                  if (lead.lastContact != null && lead.lastContact!.isNotEmpty)
                    _MetaRow(
                      icon: Icons.access_time,
                      text: 'Last contact ${lead.lastContact}',
                      color: AppColors.textHint,
                    ),
                  if (onUpdate != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {},
                      child: LeadFieldDropdowns(lead: lead, onChanged: onUpdate!),
                    ),
                  ],
                  const SizedBox(height: 8),
                  LeadQuickActions(
                    onCall: onCall,
                    onNavigate: onNavigate,
                    onEdit: onEdit,
                    onClone: onClone,
                    onTasks: onTasks,
                    onNotes: onNotes,
                    onFiles: onFiles,
                    onDelete: onDelete,
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

}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MetaRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color == AppColors.phoneLink ? AppColors.phoneLink : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
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
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
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
