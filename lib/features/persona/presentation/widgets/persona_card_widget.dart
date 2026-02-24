import 'package:flutter/material.dart';

import '../../domain/models/persona_card.dart';
import 'persona_indicator_bar.dart';

class PersonaCardWidget extends StatelessWidget {
  const PersonaCardWidget({
    super.key,
    required this.card,
    required this.onLikeTapped,
  });

  final PersonaCard card;
  final VoidCallback onLikeTapped;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _EssenceHeader(colorScheme: colorScheme, textTheme: textTheme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LifestyleReportSection(
                      report: card.aiLifestyleReport,
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 28),
                    _IndicatorsSection(
                      indicators: card.personaIndicators,
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 28),
                    _LocationChip(
                      neighborhood: card.primaryNeighborhood,
                      distance: card.relativeDistance,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
            ),
            _LikeButton(
              isLiked: card.isLiked,
              onTap: onLikeTapped,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _EssenceHeader extends StatelessWidget {
  const _EssenceHeader({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Essence',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
            ),
          ),
          const Spacer(),
          Text(
            'AI 분석 리포트',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _LifestyleReportSection extends StatelessWidget {
  const _LifestyleReportSection({
    required this.report,
    required this.textTheme,
    required this.colorScheme,
  });

  final String report;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '라이프스타일',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            report,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.85),
              height: 1.7,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorsSection extends StatelessWidget {
  const _IndicatorsSection({
    required this.indicators,
    required this.textTheme,
    required this.colorScheme,
  });

  final Map<String, double> indicators;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.insights_rounded,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 6),
            Text(
              '페르소나 지표',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PersonaIndicatorGroup(indicators: indicators),
      ],
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({
    required this.neighborhood,
    required this.distance,
    required this.colorScheme,
    required this.textTheme,
  });

  final String neighborhood;
  final double distance;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.near_me_rounded,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          Text(
            neighborhood,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onSurface.withValues(alpha: 0.25),
            ),
          ),
          Text(
            '${distance.toStringAsFixed(1)}km',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends StatefulWidget {
  const _LikeButton({
    required this.isLiked,
    required this.onTap,
    required this.colorScheme,
  });

  final bool isLiked;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(_LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked && !oldWidget.isLiked) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: widget.colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            onPressed: widget.onTap,
            style: IconButton.styleFrom(
              fixedSize: const Size(56, 56),
              backgroundColor: widget.isLiked
                  ? const Color(0xFFFCE4EC)
                  : widget.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.4),
              shape: const CircleBorder(),
            ),
            icon: Icon(
              widget.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 26,
              color: widget.isLiked
                  ? const Color(0xFFE57373)
                  : widget.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ),
      ),
    );
  }
}
