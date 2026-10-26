import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/lead.dart';

class LeadPinStyle {
  LeadPinStyle._();

  static Color colorFor(Lead lead) {
    final p = lead.priority.toLowerCase();
    if (p.contains('high')) return AppColors.primary;
    if (p.contains('medium')) return AppColors.accentOrange;
    if (p.contains('low')) return AppColors.accentPurple;
    return AppColors.primary;
  }
}
