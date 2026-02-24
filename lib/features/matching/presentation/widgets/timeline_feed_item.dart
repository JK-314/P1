import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/food_feed_entry.dart';

class TimelineFeedItem extends StatelessWidget {
  const TimelineFeedItem({
    super.key,
    required this.entry,
    required this.isFirst,
    required this.isLast,
  });

  final FoodFeedEntry entry;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('M월 d일 (E)', 'ko');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline rail
          SizedBox(
            width: 56,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 1.5,
                    height: 16,
                    color: FoodFeedColors.timelineLine,
                  )
                else
                  const SizedBox(height: 16),
                // Time dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FoodFeedColors.timelineDot,
                    border: Border.all(
                      color: FoodFeedColors.offWhite,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            FoodFeedColors.deepGreen.withValues(alpha: 0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: isLast
                        ? Colors.transparent
                        : FoodFeedColors.timelineLine,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Date and time header
                  Row(
                    children: [
                      Text(
                        dateFormat.format(entry.mealTime),
                        style: textTheme.labelSmall?.copyWith(
                          color: FoodFeedColors.mutedText,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: FoodFeedColors.timelineLine,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeFormat.format(entry.mealTime),
                        style: textTheme.labelMedium?.copyWith(
                          color: FoodFeedColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _MealTypeBadge(mealType: entry.mealType),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Food photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: FoodFeedColors.cream,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.network(
                          entry.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: FoodFeedColors.deepGreenSoft,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: FoodFeedColors.cream,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restaurant_rounded,
                                    size: 48,
                                    color: FoodFeedColors.deepGreen
                                        .withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    entry.mealType.labelKo,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: FoodFeedColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // AI comment
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 14,
                        color: FoodFeedColors.deepGreenSoft
                            .withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          entry.aiComment,
                          style: textTheme.bodySmall?.copyWith(
                            color: FoodFeedColors.mutedText,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // AI tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: entry.aiTags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: FoodFeedColors.tagBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: textTheme.labelSmall?.copyWith(
                            color: FoodFeedColors.tagText,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealTypeBadge extends StatelessWidget {
  const _MealTypeBadge({required this.mealType});

  final MealType mealType;

  Color get _color {
    return switch (mealType) {
      MealType.breakfast => const Color(0xFFE8A855),
      MealType.lunch => FoodFeedColors.deepGreenSoft,
      MealType.dinner => const Color(0xFF8B6BAE),
      MealType.snack => const Color(0xFFD4836A),
      MealType.brunch => const Color(0xFFCE9B4E),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        mealType.labelKo,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
      ),
    );
  }
}
