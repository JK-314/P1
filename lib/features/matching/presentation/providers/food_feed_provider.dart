import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/food_feed_entry.dart';

part 'food_feed_provider.g.dart';

@riverpod
class FoodFeed extends _$FoodFeed {
  @override
  FutureOr<FoodFeedData> build(String personaId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mockFeedData[personaId] ?? _defaultMockFeed;
  }
}

@riverpod
class MatchingRequest extends _$MatchingRequest {
  @override
  FutureOr<bool?> build() {
    return null;
  }

  Future<void> requestMatching(String personaId) async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    state = const AsyncData(true);
  }
}

final _defaultMockFeed = FoodFeedData(
  personaId: 'default',
  grammarSummary: const DiningGrammarSummary(
    summary:
        '주로 평일 점심은 가볍게 샐러드와 곡물 위주로, '
        '주말 저녁은 프리미엄 다이닝을 즐깁니다. '
        '아침 식사를 규칙적으로 챙기며, 고단백 식단에 대한 선호가 뚜렷합니다.',
    patterns: ['규칙적 아침 루틴', '고단백 선호', '주말 미식가', '계절 식재료 활용'],
    regularityScore: 0.87,
    healthScore: 0.82,
  ),
  entries: [
    FoodFeedEntry(
      id: 'f1',
      imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800',
      mealTime: DateTime(2026, 2, 24, 7, 30),
      mealType: MealType.breakfast,
      aiTags: ['#규칙적인_아침', '#그릭요거트', '#시리얼볼'],
      aiComment: '매일 같은 시간대에 챙기는 정돈된 아침 루틴',
    ),
    FoodFeedEntry(
      id: 'f2',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      mealTime: DateTime(2026, 2, 23, 12, 15),
      mealType: MealType.lunch,
      aiTags: ['#가벼운_점심', '#샐러드', '#건강식'],
      aiComment: '평일 점심은 가벼운 샐러드 위주로 챙기는 패턴',
    ),
    FoodFeedEntry(
      id: 'f3',
      imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      mealTime: DateTime(2026, 2, 22, 19, 0),
      mealType: MealType.dinner,
      aiTags: ['#프리미엄_다이닝', '#코스요리', '#주말_특별식'],
      aiComment: '주말 저녁에는 분위기 있는 레스토랑을 선호',
    ),
    FoodFeedEntry(
      id: 'f4',
      imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
      mealTime: DateTime(2026, 2, 22, 8, 0),
      mealType: MealType.breakfast,
      aiTags: ['#고단백', '#아보카도토스트', '#건강한_아침'],
      aiComment: '단백질 중심의 균형 잡힌 아침 식사',
    ),
    FoodFeedEntry(
      id: 'f5',
      imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
      mealTime: DateTime(2026, 2, 21, 12, 30),
      mealType: MealType.lunch,
      aiTags: ['#한식_정식', '#집밥_스타일', '#영양균형'],
      aiComment: '영양 밸런스를 고려한 한식 정식 선호',
    ),
    FoodFeedEntry(
      id: 'f6',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      mealTime: DateTime(2026, 2, 21, 18, 45),
      mealType: MealType.dinner,
      aiTags: ['#직접요리', '#홈쿠킹', '#제철재료'],
      aiComment: '제철 식재료로 직접 요리하는 저녁 시간',
    ),
    FoodFeedEntry(
      id: 'f7',
      imageUrl: 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=800',
      mealTime: DateTime(2026, 2, 20, 10, 30),
      mealType: MealType.brunch,
      aiTags: ['#주말_브런치', '#팬케이크', '#여유로운_아침'],
      aiComment: '여유로운 주말 브런치를 즐기는 모습',
    ),
  ],
);

final _mockFeedData = <String, FoodFeedData>{
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890': _defaultMockFeed,
};
