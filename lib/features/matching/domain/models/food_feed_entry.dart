import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_feed_entry.freezed.dart';
part 'food_feed_entry.g.dart';

enum MealType {
  breakfast('아침'),
  lunch('점심'),
  dinner('저녁'),
  snack('간식'),
  brunch('브런치');

  const MealType(this.labelKo);
  final String labelKo;
}

/// Step 2 식단 피드 엔트리.
/// 익명성 유지 — 얼굴, 이름 등 개인 식별 정보 절대 노출 금지.
@freezed
class FoodFeedEntry with _$FoodFeedEntry {
  const factory FoodFeedEntry({
    required String id,

    /// 식사 사진 URL (수직 촬영 기준)
    required String imageUrl,

    /// 식사 시간
    required DateTime mealTime,

    /// 식사 유형
    required MealType mealType,

    /// AI가 분석한 상황 태그 (예: #규칙적인_아침, #고단백)
    required List<String> aiTags,

    /// AI가 분석한 한줄 코멘트
    required String aiComment,
  }) = _FoodFeedEntry;

  factory FoodFeedEntry.fromJson(Map<String, dynamic> json) =>
      _$FoodFeedEntryFromJson(json);
}

/// AI가 분석한 '식사 문법' 요약 데이터
@freezed
class DiningGrammarSummary with _$DiningGrammarSummary {
  const factory DiningGrammarSummary({
    /// 전체 요약 문장
    required String summary,

    /// 주요 패턴 키워드
    required List<String> patterns,

    /// 식사 규칙성 점수 (0.0 ~ 1.0)
    required double regularityScore,

    /// 건강 지향성 점수 (0.0 ~ 1.0)
    required double healthScore,
  }) = _DiningGrammarSummary;

  factory DiningGrammarSummary.fromJson(Map<String, dynamic> json) =>
      _$DiningGrammarSummaryFromJson(json);
}

/// Step 2 전체 피드 데이터를 묶는 모델
@freezed
class FoodFeedData with _$FoodFeedData {
  const factory FoodFeedData({
    required String personaId,
    required DiningGrammarSummary grammarSummary,
    required List<FoodFeedEntry> entries,
  }) = _FoodFeedData;

  factory FoodFeedData.fromJson(Map<String, dynamic> json) =>
      _$FoodFeedDataFromJson(json);
}
