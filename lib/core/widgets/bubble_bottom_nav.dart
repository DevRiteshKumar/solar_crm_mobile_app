import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class BubbleNavItem {
  final IconData icon;
  final String label;

  const BubbleNavItem({required this.icon, required this.label});
}

class BubbleBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BubbleNavItem> items;

  const BubbleBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  static const bubbleSize = 56.0;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: currentIndex.toDouble()),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return SizedBox(
          height: 58 + bottom + 22,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final itemWidth = width / items.length;
              final cx = itemWidth * (progress + 0.5);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(width, 58 + bottom + 22),
                    painter: _BarPainter(
                      progress: progress,
                      itemCount: items.length,
                      color: AppColors.primary,
                      bottomInset: bottom,
                    ),
                  ),
                  Positioned(
                    left: cx - bubbleSize / 2,
                    top: 2,
                    child: IgnorePointer(
                      child: Container(
                        width: bubbleSize,
                        height: bubbleSize,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          items[currentIndex.clamp(0, items.length - 1)].icon,
                          size: 26,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 22,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottom),
                      child: Row(
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Expanded(
                              child: InkWell(
                                onTap: () => onTap(i),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Opacity(
                                  opacity: (i - progress).abs() < 0.35 ? 0 : 1,
                                  child: Icon(
                                    items[i].icon,
                                    size: 24,
                                    color: Colors.white.withValues(alpha: 0.92),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _BarPainter extends CustomPainter {
  final double progress;
  final int itemCount;
  final Color color;
  final double bottomInset;

  _BarPainter({
    required this.progress,
    required this.itemCount,
    required this.color,
    required this.bottomInset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final itemWidth = size.width / itemCount;
    final cx = itemWidth * (progress + 0.5);
    const r = 30.0;
    const top = 22.0;
    final path = Path();

    path.moveTo(0, top + 22);
    path.quadraticBezierTo(0, top, 22, top);

    final left = (cx - r - 20).clamp(22.0, size.width - 22);
    final right = (cx + r + 20).clamp(22.0, size.width - 22);

    path.lineTo(left, top);
    path.cubicTo(cx - r - 6, top, cx - r + 6, top + r + 4, cx, top + r + 4);
    path.cubicTo(cx + r - 6, top + r + 4, cx + r + 6, top, right, top);

    path.lineTo(size.width - 22, top);
    path.quadraticBezierTo(size.width, top, size.width, top + 22);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, AppColors.primaryDark.withValues(alpha: 0.4), 14, false);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
