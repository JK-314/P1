import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/food_feed_entry.dart';
import '../providers/food_feed_provider.dart';
import '../widgets/dining_grammar_card.dart';
import '../widgets/timeline_feed_item.dart';

class FoodFeedScreen extends ConsumerWidget {
  const FoodFeedScreen({
    super.key,
    required this.personaId,
  });

  final String personaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFeed = ref.watch(foodFeedProvider(personaId));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: FoodFeedColors.offWhite,
      body: asyncFeed.when(
        data: (feedData) => _FeedContent(
          feedData: feedData,
          personaId: personaId,
        ),
        loading: () => const _LoadingState(),
        error: (error, _) => _ErrorState(
          textTheme: textTheme,
          onRetry: () => ref.invalidate(foodFeedProvider(personaId)),
        ),
      ),
    );
  }
}

class _FeedContent extends ConsumerWidget {
  const _FeedContent({
    required this.feedData,
    required this.personaId,
  });

  final FoodFeedData feedData;
  final String personaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final matchingState = ref.watch(matchingRequestProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App bar
            SliverAppBar(
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 0.5,
              backgroundColor: FoodFeedColors.offWhite,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: FoodFeedColors.darkText,
                ),
              ),
              title: Column(
                children: [
                  Text(
                    'Eatsence',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: FoodFeedColors.darkText,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: FoodFeedColors.deepGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: FoodFeedColors.deepGreenSoft,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Step 2',
                        style: textTheme.labelSmall?.copyWith(
                          color: FoodFeedColors.deepGreen,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Step description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '식단 타임라인',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: FoodFeedColors.darkText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '이 사람의 일주일 식사 기록을 확인해보세요',
                      style: textTheme.bodyMedium?.copyWith(
                        color: FoodFeedColors.mutedText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // AI grammar summary card
            SliverToBoxAdapter(
              child: DiningGrammarCard(summary: feedData.grammarSummary),
            ),

            // Anonymity notice
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 14,
                      color: FoodFeedColors.deepGreenSoft
                          .withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '모든 개인 정보는 보호되며, 익명 상태가 유지됩니다',
                      style: textTheme.labelSmall?.copyWith(
                        color: FoodFeedColors.mutedText.withValues(alpha: 0.7),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Timeline section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 18,
                      decoration: BoxDecoration(
                        color: FoodFeedColors.deepGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '식사 로그',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: FoodFeedColors.darkText,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${feedData.entries.length}건의 기록',
                      style: textTheme.labelSmall?.copyWith(
                        color: FoodFeedColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Timeline feed items
            SliverPadding(
              padding: const EdgeInsets.only(left: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = feedData.entries[index];
                    return TimelineFeedItem(
                      entry: entry,
                      isFirst: index == 0,
                      isLast: index == feedData.entries.length - 1,
                    );
                  },
                  childCount: feedData.entries.length,
                ),
              ),
            ),

            // Bottom spacer for the CTA button
            SliverToBoxAdapter(
              child: SizedBox(height: 100 + bottomPadding),
            ),
          ],
        ),

        // Floating CTA button
        Positioned(
          left: 20,
          right: 20,
          bottom: 16 + bottomPadding,
          child: _MatchingRequestButton(
            isLoading: matchingState is AsyncLoading,
            isCompleted: matchingState.valueOrNull == true,
            onPressed: () {
              ref
                  .read(matchingRequestProvider.notifier)
                  .requestMatching(personaId);
            },
          ),
        ),
      ],
    );
  }
}

class _MatchingRequestButton extends StatelessWidget {
  const _MatchingRequestButton({
    required this.isLoading,
    required this.isCompleted,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isCompleted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: FoodFeedColors.deepGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: isCompleted
            ? FoodFeedColors.deepGreenSoft.withValues(alpha: 0.8)
            : FoodFeedColors.deepGreen,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading || isCompleted ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '요청 중...',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else if (isCompleted) ...[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '매칭 요청 완료!',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.handshake_rounded,
                    color: FoodFeedColors.accentAmber,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '최종 매칭 요청하기',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FoodFeedColors.offWhite,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2.5,
              color: FoodFeedColors.deepGreenSoft,
            ),
            SizedBox(height: 20),
            Text(
              '식단 분석 중...',
              style: TextStyle(
                color: FoodFeedColors.mutedText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.textTheme,
    required this.onRetry,
  });

  final TextTheme textTheme;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: FoodFeedColors.mutedText.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              '식단 데이터를 불러올 수 없습니다',
              style: textTheme.bodyLarge?.copyWith(
                color: FoodFeedColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('다시 시도'),
              style: TextButton.styleFrom(
                foregroundColor: FoodFeedColors.deepGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
