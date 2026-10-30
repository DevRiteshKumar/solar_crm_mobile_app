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
      padding: const EdgeInsets.only(bottom: 10),
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
                  border: Border(left: BorderSide(color: pinColor, width: 4)),
                ),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
                                      ),
                                    ),
                                  ),
                                  if (lead.leadType.trim().isNotEmpty) ...[
                                    const SizedBox(width: 6),
                                    _LeadTypeChip(type: lead.leadType),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ContactGrid(
                      phone: lead.displayPhone,
                      email: lead.displayEmail,
                      address: lead.displayAddress,
                      lastContact: lead.lastContact,
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
              child: _InfoLine(
                icon: Icons.call_outlined,
                text: phone,
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _InfoLine(
                icon: Icons.mail_outline_rounded,
                text: email,
                iconColor: const Color(0xFF1565C0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _InfoLine(
                icon: Icons.location_on_outlined,
                text: address,
                iconColor: AppColors.accentOrange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _InfoLine(
                icon: Icons.access_time,
                text: lastContact?.trim().isNotEmpty == true ? lastContact! : '-',
                iconColor: const Color(0xFF00897B),
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
  final Color iconColor;

  const _InfoLine({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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

  Color get _color {
    final value = type.toLowerCase();
    if (value.contains('commercial')) return const Color(0xFF1565C0);
    if (value.contains('industrial')) return const Color(0xFF6A1B9A);
    return const Color(0xFF2E7D32);
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
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
          width: 36,
          height: 36,
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
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, size: 12, color: AppColors.success),
            ),
          ),
      ],
    );
  }
}
