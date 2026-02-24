import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_profile.dart';

part 'persona_card.freezed.dart';
part 'persona_card.g.dart';

/// Step 1 AI 페르소나 카드.
/// 완전 익명성 유지 — 개인 신상(이름, 나이, 사진) 절대 노출 금지.
/// [isFinalMatched]가 true일 때만 [revealedProfile]을 통해 실제 프로필에 접근 가능.
@freezed
class PersonaCard with _$PersonaCard {
  const PersonaCard._();

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

    /// 최종 매칭 확정 여부 (Step 3 상호 동의 완료 시 true)
    @Default(false) bool isFinalMatched,

    /// 매칭 확정 후 공개되는 실제 사용자 프로필 (내부 저장용)
    UserProfile? userProfile,
  }) = _PersonaCard;

  /// 매칭이 확정된 경우에만 [UserProfile]을 반환.
  /// [isFinalMatched]가 false이면 null을 반환하여 익명성을 보장한다.
  UserProfile? get revealedProfile => isFinalMatched ? userProfile : null;

  factory PersonaCard.fromJson(Map<String, dynamic> json) =>
      _$PersonaCardFromJson(json);
}
