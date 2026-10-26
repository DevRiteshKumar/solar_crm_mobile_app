import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class LeadQuickActions extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onNavigate;
  final VoidCallback onCheckIn;
  final bool checkedIn;

  const LeadQuickActions({
    super.key,
    required this.onCall,
    required this.onWhatsApp,
    required this.onNavigate,
    required this.onCheckIn,
    this.checkedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Action(
            icon: Icons.call_outlined,
            label: 'Call',
            color: AppColors.primary,
            onTap: onCall,
          ),
          _Action(
            icon: Icons.chat_outlined,
            label: 'WhatsApp',
            color: const Color(0xFF128C7E),
            onTap: onWhatsApp,
          ),
          _Action(
            icon: Icons.near_me_outlined,
            label: 'Navigate',
            color: AppColors.accentBlue,
            onTap: onNavigate,
          ),
          _Action(
            icon: checkedIn ? Icons.check_circle : Icons.person_pin_circle_outlined,
            label: checkedIn ? 'Checked In' : 'Check In',
            color: checkedIn ? AppColors.success : AppColors.accentOrange,
            filled: checkedIn,
            onTap: onCheckIn,
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
  final bool filled;

  const _Action({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: filled ? color : color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 17, color: filled ? Colors.white : color),
              ),
              const SizedBox(height: 4),
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
