import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

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
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          _Pill(
            icon: Icons.call_outlined,
            label: 'Call',
            background: const Color(0xFFFFE4EC),
            foreground: AppColors.primary,
            flex: 3,
            onTap: onCall,
          ),
          const SizedBox(width: 6),
          _Pill(
            icon: Icons.send_outlined,
            label: 'Navigation',
            background: const Color(0xFFE8F5E9),
            foreground: const Color(0xFF2E7D32),
            flex: 5,
            onTap: onNavigate,
          ),
          const SizedBox(width: 6),
          _Pill(
            icon: Icons.sticky_note_2_outlined,
            label: 'Notes',
            background: const Color(0xFFE3F2FD),
            foreground: const Color(0xFF1565C0),
            flex: 3,
            onTap: onNotes,
          ),
          const SizedBox(width: 6),
          _Pill(
            icon: Icons.check_circle_outline,
            label: 'Tasks',
            background: const Color(0xFFFFF3E0),
            foreground: const Color(0xFFEF6C00),
            flex: 3,
            onTap: onTasks,
          ),
          const SizedBox(width: 6),
          _Pill(
            icon: Icons.more_horiz,
            label: 'More',
            background: Colors.white,
            foreground: AppColors.textPrimary,
            flex: 3,
            outlined: true,
            onTap: () => _showMore(context),
          ),
        ],
      ),
    );
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'More actions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                _MoreTile(icon: Icons.folder_outlined, label: 'Files', color: const Color(0xFF3949AB), onTap: onFiles),
                _MoreTile(icon: Icons.edit_outlined, label: 'Edit', color: AppColors.accentOrange, onTap: onEdit),
                _MoreTile(icon: Icons.delete_outline, label: 'Delete', color: AppColors.primary, onTap: onDelete),
                _MoreTile(icon: Icons.filter_none_outlined, label: 'Clone', color: AppColors.accentPurple, onTap: onClone),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final int flex;
  final bool outlined;

  const _Pill({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.flex = 3,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: outlined ? Border.all(color: const Color(0xFFE5E7EB)) : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 13, color: foreground),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
