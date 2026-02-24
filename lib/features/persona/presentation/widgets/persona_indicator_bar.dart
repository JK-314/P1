import 'package:flutter/material.dart';

class PersonaIndicatorBar extends StatelessWidget {
  const PersonaIndicatorBar({
    super.key,
    required this.label,
    required this.value,
    this.activeColor,
  });

  final String label;

  /// 0.0 ~ 1.0
  final double value;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = activeColor ?? colorScheme.primary;
    final percentage = (value * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                '$percentage',
                style: textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _AnimatedGaugeBar(value: value, color: color),
        ],
      ),
    );
  }
}

class _AnimatedGaugeBar extends StatefulWidget {
  const _AnimatedGaugeBar({
    required this.value,
    required this.color,
  });

  final double value;
  final Color color;

  @override
  State<_AnimatedGaugeBar> createState() => _AnimatedGaugeBarState();
}

class _AnimatedGaugeBarState extends State<_AnimatedGaugeBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedGaugeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackColor =
        Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 6),
          painter: _GaugeBarPainter(
            progress: widget.value * _animation.value,
            activeColor: widget.color,
            trackColor: trackColor,
          ),
        );
      },
    );
  }
}

class _GaugeBarPainter extends CustomPainter {
  _GaugeBarPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  final double progress;
  final Color activeColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.fill;

    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    canvas.drawRRect(trackRect, trackPaint);

    if (progress > 0) {
      final fillWidth = size.width * progress.clamp(0.0, 1.0);

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            activeColor.withValues(alpha: 0.7),
            activeColor,
          ],
        ).createShader(Rect.fromLTWH(0, 0, fillWidth, size.height))
        ..style = PaintingStyle.fill;

      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, fillWidth, size.height),
        Radius.circular(radius),
      );
      canvas.drawRRect(fillRect, fillPaint);
    }
  }

  @override
  bool shouldRepaint(_GaugeBarPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeColor != activeColor;
}

class PersonaIndicatorGroup extends StatelessWidget {
  const PersonaIndicatorGroup({
    super.key,
    required this.indicators,
  });

  final Map<String, double> indicators;

  static const _indicatorColors = [
    Color(0xFF7C9A92),
    Color(0xFF9AB87A),
    Color(0xFF8B9DC3),
    Color(0xFFC4956A),
  ];

  @override
  Widget build(BuildContext context) {
    final entries = indicators.entries.toList();

    return Column(
      children: List.generate(entries.length, (i) {
        final entry = entries[i];
        return PersonaIndicatorBar(
          label: entry.key,
          value: entry.value,
          activeColor: _indicatorColors[i % _indicatorColors.length],
        );
      }),
    );
  }
}
