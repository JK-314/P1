import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona_card.freezed.dart';
part 'persona_card.g.dart';

/// Step 1 AI 페르소나 카드.
/// 완전 익명성 유지 — 개인 신상(이름, 나이, 사진) 절대 노출 금지.
@freezed
class PersonaCard with _$PersonaCard {
  const factory PersonaCard({
    /// 고유 식별자 (UUID)
    required String id,

    /// AI가 생성한 요약 라이프스타일 리포트
    required String aiLifestyleReport,

    /// 4대 페르소나 지표 (0.0 ~ 1.0)
    /// keys: '경제력', '건강', '생활 리듬', '가치관'
    required Map<String, double> personaIndicators,

    /// 주요 활동 동네
    required String primaryNeighborhood,

    /// 상대적 거리 (km 단위)
    required double relativeDistance,

    /// 좋아요 상태
    @Default(false) bool isLiked,
  }) = _PersonaCard;

  factory PersonaCard.fromJson(Map<String, dynamic> json) =>
      _$PersonaCardFromJson(json);
}
