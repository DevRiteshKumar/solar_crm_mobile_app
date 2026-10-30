import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class LeadQuickActions extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onNavigate;
  final VoidCallback onEdit;
  final VoidCallback onClone;
  final VoidCallback onTasks;
  final VoidCallback onNotes;
  final VoidCallback onFiles;
  final VoidCallback onDelete;

  const LeadQuickActions({
    super.key,
    required this.onCall,
    required this.onNavigate,
    required this.onEdit,
    required this.onClone,
    required this.onTasks,
    required this.onNotes,
    required this.onFiles,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Action(icon: Icons.call_outlined, label: 'Call', color: AppColors.primary, onTap: onCall),
              _Action(icon: Icons.send_outlined, label: 'Navigation', color: AppColors.accentBlue, onTap: onNavigate),
              _Action(icon: Icons.edit_outlined, label: 'Edit', color: AppColors.accentOrange, onTap: onEdit),
              _Action(icon: Icons.check_circle_outline, label: 'Tasks', color: const Color(0xFF00897B), onTap: onTasks),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              _Action(icon: Icons.sticky_note_2_outlined, label: 'Notes', color: const Color(0xFFF57C00), onTap: onNotes),
              _Action(icon: Icons.folder_outlined, label: 'Files', color: const Color(0xFF3949AB), onTap: onFiles),
              _Action(icon: Icons.delete_outline, label: 'Delete', color: AppColors.primary, onTap: onDelete),
              _Action(icon: Icons.filter_none_outlined, label: 'Clone', color: AppColors.accentPurple, onTap: onClone),
            ],
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _Action({
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
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
