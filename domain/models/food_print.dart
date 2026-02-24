import 'package:flutter/foundation.dart';

/// 개별 식사 기록 (Immutable)
@immutable
class MealLog {
  final String imageUrl;
  final DateTime mealTime;
  final String menuName;
  final String mood;

  const MealLog({
    required this.imageUrl,
    required this.mealTime,
    required this.menuName,
    required this.mood,
  });

  MealLog copyWith({
    String? imageUrl,
    DateTime? mealTime,
    String? menuName,
    String? mood,
  }) {
    return MealLog(
      imageUrl: imageUrl ?? this.imageUrl,
      mealTime: mealTime ?? this.mealTime,
      menuName: menuName ?? this.menuName,
      mood: mood ?? this.mood,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealLog &&
          runtimeType == other.runtimeType &&
          imageUrl == other.imageUrl &&
          mealTime == other.mealTime &&
          menuName == other.menuName &&
          mood == other.mood;

  @override
  int get hashCode => Object.hash(imageUrl, mealTime, menuName, mood);

  @override
  String toString() =>
      'MealLog(menuName: $menuName, mealTime: $mealTime, mood: $mood)';
}

/// FoodPrint 상세 페이지 전체 데이터 (Immutable)
/// [personaId]를 통해 PersonaCard와 연결됩니다.
@immutable
class FoodPrint {
  final String personaId;
  final bool isMutualLike;
  final List<MealLog> mealLogs;
  final String aiAnalysisSummary;
  final List<String> frequentAreaTags;

  FoodPrint({
    required this.personaId,
    required this.isMutualLike,
    required this.mealLogs,
    required this.aiAnalysisSummary,
    required this.frequentAreaTags,
  })  : mealLogs = List.unmodifiable(mealLogs),
        frequentAreaTags = List.unmodifiable(frequentAreaTags);

  FoodPrint copyWith({
    String? personaId,
    bool? isMutualLike,
    List<MealLog>? mealLogs,
    String? aiAnalysisSummary,
    List<String>? frequentAreaTags,
  }) {
    return FoodPrint(
      personaId: personaId ?? this.personaId,
      isMutualLike: isMutualLike ?? this.isMutualLike,
      mealLogs: mealLogs ?? this.mealLogs,
      aiAnalysisSummary: aiAnalysisSummary ?? this.aiAnalysisSummary,
      frequentAreaTags: frequentAreaTags ?? this.frequentAreaTags,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodPrint &&
          runtimeType == other.runtimeType &&
          personaId == other.personaId &&
          isMutualLike == other.isMutualLike &&
          listEquals(mealLogs, other.mealLogs) &&
          aiAnalysisSummary == other.aiAnalysisSummary &&
          listEquals(frequentAreaTags, other.frequentAreaTags);

  @override
  int get hashCode => Object.hash(
        personaId,
        isMutualLike,
        Object.hashAll(mealLogs),
        aiAnalysisSummary,
        Object.hashAll(frequentAreaTags),
      );

  @override
  String toString() =>
      'FoodPrint(personaId: $personaId, isMutualLike: $isMutualLike, '
      'mealLogs: ${mealLogs.length} items, '
      'aiAnalysisSummary: $aiAnalysisSummary, '
      'frequentAreaTags: $frequentAreaTags)';
}
