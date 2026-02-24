import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../matching/domain/models/food_feed_entry.dart';
import '../../domain/entities/user_profile.dart';

part 'identity_reveal_provider.g.dart';

/// Step 3 정체 공개 데이터를 묶는 모델
class IdentityRevealData {
  const IdentityRevealData({
    required this.profile,
    required this.grammarSummary,
    required this.personaId,
  });

  final UserProfile profile;
  final DiningGrammarSummary grammarSummary;
  final String personaId;
}

@riverpod
class IdentityReveal extends _$IdentityReveal {
  @override
  FutureOr<IdentityRevealData> build(String personaId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockRevealData[personaId] ?? _defaultRevealData;
  }
}

final _defaultRevealData = IdentityRevealData(
  personaId: 'default',
  profile: const UserProfile(
    id: 'user-001',
    nickname: '하늘빛 미식가',
    age: 28,
    gender: '여성',
    profileImageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    todayFoodKeywords: ['#비건점심', '#와인바', '#브런치카페'],
  ),
  grammarSummary: const DiningGrammarSummary(
    summary: '주로 평일 점심은 가볍게 샐러드와 곡물 위주로, '
        '주말 저녁은 프리미엄 다이닝을 즐깁니다. '
        '아침 식사를 규칙적으로 챙기며, 고단백 식단에 대한 선호가 뚜렷합니다.',
    patterns: ['규칙적 아침 루틴', '고단백 선호', '주말 미식가', '계절 식재료 활용'],
    regularityScore: 0.87,
    healthScore: 0.82,
  ),
);

final _mockRevealData = <String, IdentityRevealData>{
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890': _defaultRevealData,
};
