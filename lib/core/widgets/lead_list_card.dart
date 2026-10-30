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
    final name = lead.customerName.trim().isNotEmpty ? lead.customerName : lead.businessName;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? pinColor.withValues(alpha: 0.45) : AppColors.border,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LeadAvatar(
                        label: showIndex ? '$index' : _initials(name),
                        color: pinColor,
                        checkedIn: checkedIn,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                                if (lead.leadType.trim().isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  _LeadTypeChip(type: lead.leadType),
                                ],
                              ],
                            ),
                            const SizedBox(height: 6),
                            _ContactGrid(
                              phone: lead.displayPhone,
                              email: lead.displayEmail,
                              address: lead.displayAddress,
                              lastContact: lead.lastContact,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textHint),
                      ),
                    ],
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
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _ContactGrid extends StatelessWidget {
  final String phone;
  final String email;
  final String address;
  final String? lastContact;

  const _ContactGrid({
    required this.phone,
    required this.email,
    required this.address,
    required this.lastContact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoLine(icon: Icons.call_outlined, text: phone),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoLine(icon: Icons.mail_outline_rounded, text: email),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _InfoLine(icon: Icons.location_on_outlined, text: address),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoLine(
                icon: Icons.access_time,
                text: lastContact?.trim().isNotEmpty == true ? lastContact! : '-',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.25,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _LeadTypeChip extends StatelessWidget {
  final String type;

  const _LeadTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.tile,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
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
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (checkedIn)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, size: 12, color: AppColors.success),
            ),
          ),
      ],
    );
  }
}
