import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_entity.freezed.dart';

enum MatchStep {
  step1Persona,
  step2Bridge,
  step3Connection,
}

/// Represents a match between two anonymous personas.
/// No personal identifiers are included until Step 3 mutual consent.
@freezed
class MatchEntity with _$MatchEntity {
  const factory MatchEntity({
    required String id,
    required String personaAId,
    required String personaBId,
    required MatchStep currentStep,
    required double compatibilityScore,
    required Map<String, double> categoryScores,
    required DateTime createdAt,
    @Default(false) bool mutualConsent,
  }) = _MatchEntity;
}
