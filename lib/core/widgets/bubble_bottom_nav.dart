import 'package:flutter/material.dart';

class BubbleNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const BubbleNavItem({
    required this.icon,
    required this.label,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
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

  static const bubbleSize = 50.0;
  static const barHeight = 56.0;
  static const notchLift = 40.0;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: currentIndex.toDouble()),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return SizedBox(
          height: barHeight + bottom + notchLift,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final itemWidth = width / items.length;
              final cx = itemWidth * (progress + 0.5);
              final selected = currentIndex.clamp(0, items.length - 1);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(width, barHeight + bottom + notchLift),
                    painter: _BarPainter(
                      progress: progress,
                      itemCount: items.length,
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
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          items[selected].activeIcon,
                          size: 24,
                          color: const Color(0xFF5C5866),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: notchLift,
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottom),
                      child: Row(
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Expanded(
                              child: _NavSlot(
                                item: items[i],
                                selected: (i - progress).abs() < 0.35,
                                onTap: () => onTap(i),
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

class _NavSlot extends StatelessWidget {
  final BubbleNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavSlot({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Opacity(
        opacity: selected ? 0 : 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 22, color: Colors.white.withValues(alpha: 0.92)),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final double progress;
  final int itemCount;
  final double bottomInset;

  _BarPainter({
    required this.progress,
    required this.itemCount,
    required this.bottomInset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final itemWidth = size.width / itemCount;
    final cx = itemWidth * (progress + 0.5);
    const r = 22.0;
    const top = BubbleBottomNav.notchLift;
    final path = Path();

    path.moveTo(0, top + 18);
    path.quadraticBezierTo(0, top, 18, top);

    final left = (cx - r - 18).clamp(18.0, size.width - 18);
    final right = (cx + r + 18).clamp(18.0, size.width - 18);

    path.lineTo(left, top);
    path.cubicTo(cx - r - 2, top, cx - r + 6, top + r, cx, top + r);
    path.cubicTo(cx + r - 6, top + r, cx + r + 2, top, right, top);

    path.lineTo(size.width - 18, top);
    path.quadraticBezierTo(size.width, top, size.width, top + 18);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.22), 16, false);
    canvas.drawPath(path, Paint()..color = const Color(0xFF7A7683));
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
