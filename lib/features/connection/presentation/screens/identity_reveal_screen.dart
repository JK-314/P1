import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../matching/domain/models/food_feed_entry.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/identity_reveal_provider.dart';

class IdentityRevealScreen extends ConsumerWidget {
  const IdentityRevealScreen({
    super.key,
    required this.personaId,
  });

  final String personaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReveal = ref.watch(identityRevealProvider(personaId));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: FoodFeedColors.offWhite,
      body: asyncReveal.when(
        data: (data) => _RevealContent(
          data: data,
          personaId: personaId,
        ),
        loading: () => const _LoadingState(),
        error: (error, _) => _ErrorState(
          textTheme: textTheme,
          onRetry: () => ref.invalidate(identityRevealProvider(personaId)),
        ),
      ),
    );
  }
}

class _RevealContent extends StatefulWidget {
  const _RevealContent({
    required this.data,
    required this.personaId,
  });

  final IdentityRevealData data;
  final String personaId;

  @override
  State<_RevealContent> createState() => _RevealContentState();
}

class _RevealContentState extends State<_RevealContent>
    with TickerProviderStateMixin {
  late final AnimationController _unveilController;
  late final AnimationController _contentController;
  late final AnimationController _shimmerController;

  late final Animation<double> _personaFadeOut;
  late final Animation<double> _profileFadeIn;
  late final Animation<double> _profileScale;
  late final Animation<double> _contentSlideUp;
  late final Animation<double> _contentFade;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _unveilController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _personaFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _unveilController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _profileFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _unveilController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    _profileScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _unveilController,
        curve: const Interval(0.3, 0.75, curve: Curves.elasticOut),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _unveilController,
        curve: const Interval(0.4, 0.85, curve: Curves.easeInOut),
      ),
    );

    _contentSlideUp = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOutCubic,
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _unveilController.forward();
    });

    _unveilController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _unveilController.dispose();
    _contentController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final profile = widget.data.profile;
    final summary = widget.data.grammarSummary;

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(textTheme),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildUnveilingArea(profile, textTheme),
                  const SizedBox(height: 8),
                  _buildProfileInfo(profile, textTheme),
                  const SizedBox(height: 28),
                  _buildDietSummaryCard(summary, textTheme),
                  const SizedBox(height: 16),
                  _buildConnectionMessage(textTheme),
                  SizedBox(height: 100 + bottomPadding),
                ],
              ),
            ),
          ],
        ),

        // Floating CTA
        Positioned(
          left: 20,
          right: 20,
          bottom: 16 + bottomPadding,
          child: AnimatedBuilder(
            animation: _contentController,
            builder: (context, child) => Opacity(
              opacity: _contentFade.value,
              child: Transform.translate(
                offset: Offset(0, _contentSlideUp.value),
                child: child,
              ),
            ),
            child: _SendFirstMessageButton(
              onPressed: () {
                context.push('/chat/${widget.personaId}');
              },
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar(TextTheme textTheme) {
    return SliverAppBar(
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
      title: Text(
        'Eatsence',
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: FoodFeedColors.darkText,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FoodFeedColors.accentAmber.withValues(alpha: 0.12),
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
                  color: FoodFeedColors.accentAmber,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Step 3',
                style: textTheme.labelSmall?.copyWith(
                  color: FoodFeedColors.accentAmber,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnveilingArea(UserProfile profile, TextTheme textTheme) {
    return SizedBox(
      height: 200,
      child: AnimatedBuilder(
        animation: Listenable.merge([_unveilController, _shimmerController]),
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Glow ring behind the profile
              if (_glowPulse.value > 0)
                Container(
                  width: 160 + (_glowPulse.value * 20),
                  height: 160 + (_glowPulse.value * 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        FoodFeedColors.accentAmber
                            .withValues(alpha: 0.15 * _glowPulse.value),
                        FoodFeedColors.accentAmber.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),

              // Anonymous persona card (fading out)
              if (_personaFadeOut.value > 0.01)
                Opacity(
                  opacity: _personaFadeOut.value,
                  child: _AnonymousPersonaAvatar(
                    shimmerValue: _shimmerController.value,
                    fadeProgress: 1.0 - _personaFadeOut.value,
                  ),
                ),

              // Real profile photo (fading in + scaling)
              if (_profileFadeIn.value > 0.01)
                Opacity(
                  opacity: _profileFadeIn.value,
                  child: Transform.scale(
                    scale: _profileScale.value,
                    child: _RealProfileAvatar(
                      imageUrl: profile.profileImageUrl,
                      glowIntensity: _glowPulse.value,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(UserProfile profile, TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _unveilController,
      builder: (context, child) {
        final infoFade = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
              parent: _unveilController,
              curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
            ))
            .value;

        final infoSlide = Tween<double>(begin: 20.0, end: 0.0)
            .animate(CurvedAnimation(
              parent: _unveilController,
              curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
            ))
            .value;

        return Opacity(
          opacity: infoFade,
          child: Transform.translate(
            offset: Offset(0, infoSlide),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              profile.nickname,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: FoodFeedColors.darkText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _InfoChip(
                  icon: Icons.cake_rounded,
                  label: '${profile.age}세',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.person_rounded,
                  label: profile.gender,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietSummaryCard(
      DiningGrammarSummary summary, TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) => Opacity(
        opacity: _contentFade.value,
        child: Transform.translate(
          offset: Offset(0, _contentSlideUp.value),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: FoodFeedColors.cream,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: FoodFeedColors.warmGray.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: FoodFeedColors.cream.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: FoodFeedColors.tagBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        size: 16,
                        color: FoodFeedColors.tagText,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '식단 라이프스타일',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: FoodFeedColors.darkText,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '이 사람이 바로 그 라이프스타일의 주인공입니다',
                            style: textTheme.labelSmall?.copyWith(
                              color: FoodFeedColors.accentAmber,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Summary text
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: Text(
                  summary.summary,
                  style: textTheme.bodySmall?.copyWith(
                    color: FoodFeedColors.mutedText,
                    height: 1.6,
                  ),
                ),
              ),

              // Pattern tags
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: summary.patterns.map((pattern) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: FoodFeedColors.tagBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pattern,
                        style: textTheme.labelSmall?.copyWith(
                          color: FoodFeedColors.tagText,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Score bars
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _MiniScoreBar(
                        label: '규칙성',
                        score: summary.regularityScore,
                        color: FoodFeedColors.deepGreenSoft,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _MiniScoreBar(
                        label: '건강 지향',
                        score: summary.healthScore,
                        color: FoodFeedColors.accentAmber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionMessage(TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) => Opacity(
        opacity: _contentFade.value,
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_rounded,
              size: 14,
              color: FoodFeedColors.deepGreenSoft.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              '상호 동의가 완료되어 신원이 공개되었습니다',
              style: textTheme.labelSmall?.copyWith(
                color: FoodFeedColors.mutedText.withValues(alpha: 0.7),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Anonymous Persona Avatar (fading out) ───

class _AnonymousPersonaAvatar extends StatelessWidget {
  const _AnonymousPersonaAvatar({
    required this.shimmerValue,
    required this.fadeProgress,
  });

  final double shimmerValue;
  final double fadeProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FoodFeedColors.warmGray.withValues(alpha: 0.3),
            FoodFeedColors.cream,
            FoodFeedColors.warmGray.withValues(alpha: 0.2),
          ],
          stops: [
            math.max(0.0, shimmerValue - 0.3),
            shimmerValue,
            math.min(1.0, shimmerValue + 0.3),
          ],
        ),
        border: Border.all(
          color: FoodFeedColors.cream,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 40,
            color: FoodFeedColors.warmGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 4),
          Text(
            '???',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: FoodFeedColors.warmGray.withValues(alpha: 0.5),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Real Profile Avatar (fading in) ───

class _RealProfileAvatar extends StatelessWidget {
  const _RealProfileAvatar({
    required this.imageUrl,
    required this.glowIntensity,
  });

  final String imageUrl;
  final double glowIntensity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: FoodFeedColors.accentAmber
                .withValues(alpha: 0.25 * glowIntensity),
            blurRadius: 24 * glowIntensity,
            spreadRadius: 4 * glowIntensity,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: FoodFeedColors.darkText.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: FoodFeedColors.cream,
              child: const Icon(
                Icons.person_rounded,
                size: 50,
                color: FoodFeedColors.warmGray,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Info Chip ───

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FoodFeedColors.cream.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: FoodFeedColors.warmGray,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: FoodFeedColors.darkText.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mini Score Bar ───

class _MiniScoreBar extends StatelessWidget {
  const _MiniScoreBar({
    required this.label,
    required this.score,
    required this.color,
  });

  final String label;
  final double score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: FoodFeedColors.mutedText,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(score * 100).toInt()}%',
              style: textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: FoodFeedColors.cream,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: score,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Send First Message Button (CTA) ───

class _SendFirstMessageButton extends StatelessWidget {
  const _SendFirstMessageButton({
    required this.onPressed,
  });

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
        color: FoodFeedColors.deepGreen,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_rounded,
                  color: FoodFeedColors.accentAmber,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  '첫 메시지 보내기',
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
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Loading & Error States ───

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
              color: FoodFeedColors.accentAmber,
            ),
            SizedBox(height: 20),
            Text(
              '프로필을 준비하고 있습니다...',
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
              '프로필 정보를 불러올 수 없습니다',
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
