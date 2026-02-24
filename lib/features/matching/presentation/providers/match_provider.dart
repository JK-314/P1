import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/match_entity.dart';
import '../../../../core/router/app_router.dart';

part 'match_provider.g.dart';

@immutable
class MatchState {
  const MatchState({
    this.likedUserIds = const {},
    this.currentMatch,
    this.isProcessing = false,
  });

  final Set<String> likedUserIds;
  final MatchEntity? currentMatch;
  final bool isProcessing;

  bool isLiked(String userId) => likedUserIds.contains(userId);

  MatchState copyWith({
    Set<String>? likedUserIds,
    MatchEntity? currentMatch,
    bool? isProcessing,
  }) {
    return MatchState(
      likedUserIds: likedUserIds ?? this.likedUserIds,
      currentMatch: currentMatch ?? this.currentMatch,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

@riverpod
class Match extends _$Match {
  @override
  MatchState build() {
    return const MatchState();
  }

  void likeUser(String userId) {
    if (state.likedUserIds.contains(userId)) return;

    state = state.copyWith(
      likedUserIds: {...state.likedUserIds, userId},
    );
  }

  void unlikeUser(String userId) {
    final updated = {...state.likedUserIds}..remove(userId);
    state = state.copyWith(likedUserIds: updated);
  }

  void toggleLike(String userId) {
    if (state.isLiked(userId)) {
      unlikeUser(userId);
    } else {
      likeUser(userId);
    }
  }

  /// Simulates a mutual like (match) scenario.
  ///
  /// Adds the [userId] to liked list, waits briefly to mimic a server
  /// round-trip, then creates a [MatchEntity] representing a successful
  /// mutual match and navigates to the Step 2 FoodFeedScreen.
  Future<void> simulateMatch(String userId) async {
    state = state.copyWith(isProcessing: true);

    likeUser(userId);

    await Future<void>.delayed(const Duration(milliseconds: 800));

    final match = MatchEntity(
      id: 'match_${DateTime.now().millisecondsSinceEpoch}',
      personaAId: 'current_user',
      personaBId: userId,
      currentStep: MatchStep.step2Bridge,
      compatibilityScore: 0.85,
      categoryScores: const {
        '경제력': 0.78,
        '건강': 0.82,
        '생활 리듬': 0.90,
        '가치관': 0.88,
      },
      createdAt: DateTime.now(),
      mutualConsent: true,
    );

    state = state.copyWith(
      currentMatch: match,
      isProcessing: false,
    );

    ref.read(appRouterProvider).go('/food-feed');
  }
}
