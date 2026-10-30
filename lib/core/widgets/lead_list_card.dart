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
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(
                      initials: showIndex
                          ? '$index'
                          : _initials(
                              lead.customerName.trim().isNotEmpty
                                  ? lead.customerName
                                  : lead.businessName,
                            ),
                      color: pinColor,
                      checkedIn: checkedIn,
                      name: lead.customerName.trim().isNotEmpty
                          ? lead.customerName
                          : lead.businessName,
                      leadType: lead.leadType,
                      lastContact: lead.lastContact,
                      onMore: onMore,
                    ),
                    const SizedBox(height: 10),
                    _ContactBlock(
                      phone: lead.displayPhone,
                      email: lead.displayEmail,
                      address: lead.displayAddress,
                      accent: pinColor,
                    ),
                    if (onUpdate != null) ...[
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: LeadFieldDropdowns(lead: lead, onChanged: onUpdate!),
                      ),
                    ],
                    const SizedBox(height: 10),
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

class _Header extends StatelessWidget {
  final String initials;
  final Color color;
  final bool checkedIn;
  final String name;
  final String leadType;
  final String? lastContact;
  final VoidCallback? onMore;

  const _Header({
    required this.initials,
    required this.color,
    required this.checkedIn,
    required this.name,
    required this.leadType,
    required this.lastContact,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LeadAvatar(label: initials, color: color, checkedIn: checkedIn),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (leadType.trim().isNotEmpty) ...[
                    const SizedBox(width: 6),
                    _LeadTypeChip(type: leadType),
                  ],
                ],
              ),
              if (lastContact != null && lastContact!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Last contact $lastContact',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
    );
  }
}

class _ContactBlock extends StatelessWidget {
  final String phone;
  final String email;
  final String address;
  final Color accent;

  const _ContactBlock({
    required this.phone,
    required this.email,
    required this.address,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetaRow(
                  icon: Icons.call_outlined,
                  text: phone,
                  color: AppColors.phoneLink,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetaRow(
                  icon: Icons.mail_outline_rounded,
                  text: email,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _MetaRow(
            icon: Icons.location_on_outlined,
            text: address,
            color: accent,
          ),
        ],
      ),
    );
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
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
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
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
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
