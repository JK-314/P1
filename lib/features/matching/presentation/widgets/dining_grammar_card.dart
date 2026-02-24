import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/food_feed_entry.dart';

class DiningGrammarCard extends StatelessWidget {
  const DiningGrammarCard({
    super.key,
    required this.summary,
  });

  final DiningGrammarSummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FoodFeedColors.deepGreen,
            FoodFeedColors.deepGreenLight,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: FoodFeedColors.deepGreen.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: FoodFeedColors.accentAmber,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI 식사 문법 분석',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            summary.summary,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.65,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: summary.patterns.map((pattern) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Text(
                  pattern,
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _ScoreIndicator(
                label: '규칙성',
                score: summary.regularityScore,
              ),
              const SizedBox(width: 16),
              _ScoreIndicator(
                label: '건강 지향',
                score: summary.healthScore,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreIndicator extends StatelessWidget {
  const _ScoreIndicator({
    required this.label,
    required this.score,
  });

  final String label;
  final double score;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percentage = (score * 100).round();

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: textTheme.labelMedium?.copyWith(
                    color: FoodFeedColors.accentAmber,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: score,
                minHeight: 4,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  FoodFeedColors.accentAmber,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
