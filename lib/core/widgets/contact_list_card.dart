import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/contact.dart';

class ContactListCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onMore;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onEmail;
  final VoidCallback onEdit;

  const ContactListCard({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onMore,
    required this.onCall,
    required this.onWhatsApp,
    required this.onEmail,
    required this.onEdit,
  });

  String get _address {
    final parts = [
      contact.streetAddress,
      contact.city,
      contact.state,
    ].where((p) => p != null && p.trim().isNotEmpty).map((p) => p!.trim());
    if (parts.isEmpty) return '-';
    return parts.join(', ');
  }

  String get _chipLabel {
    if (contact.companyName != null && contact.companyName!.trim().isNotEmpty) {
      return contact.companyName!.trim();
    }
    if (contact.jobTitle != null && contact.jobTitle!.trim().isNotEmpty) {
      return contact.jobTitle!.trim();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
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
              border: Border.all(color: AppColors.border),
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
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
                ),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Avatar(label: _initials(contact.fullName)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  contact.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              if (_chipLabel.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                _TypeChip(label: _chipLabel),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _InfoLine(
                                icon: Icons.call_outlined,
                                text: contact.phone1,
                                iconColor: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _InfoLine(
                                icon: Icons.mail_outline_rounded,
                                text: (contact.email != null && contact.email!.trim().isNotEmpty)
                                    ? contact.email!
                                    : '-',
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
                                text: _address,
                                iconColor: AppColors.accentOrange,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _InfoLine(
                                icon: Icons.category_outlined,
                                text: (contact.industry != null && contact.industry!.trim().isNotEmpty)
                                    ? contact.industry!
                                    : (contact.jobTitle ?? '-'),
                                iconColor: const Color(0xFF00897B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
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
                            icon: Icons.chat_outlined,
                            label: 'WhatsApp',
                            background: const Color(0xFFE8F5E9),
                            foreground: const Color(0xFF2E7D32),
                            flex: 4,
                            onTap: onWhatsApp,
                          ),
                          const SizedBox(width: 6),
                          _Pill(
                            icon: Icons.mail_outline_rounded,
                            label: 'Email',
                            background: const Color(0xFFE3F2FD),
                            foreground: const Color(0xFF1565C0),
                            flex: 3,
                            onTap: onEmail,
                          ),
                          const SizedBox(width: 6),
                          _Pill(
                            icon: Icons.more_horiz,
                            label: 'More',
                            background: Colors.white,
                            foreground: AppColors.textPrimary,
                            flex: 3,
                            outlined: true,
                            onTap: onMore,
                          ),
                        ],
                      ),
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

class _Avatar extends StatelessWidget {
  final String label;

  const _Avatar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
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
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;

  const _TypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1565C0),
        ),
      ),
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
            height: 28,
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
                  Icon(icon, size: 14, color: foreground),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
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
