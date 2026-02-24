import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/persona_card.dart';
import '../../domain/models/user_profile.dart';

part 'persona_card_provider.g.dart';

@riverpod
class PersonaCardList extends _$PersonaCardList {
  @override
  FutureOr<List<PersonaCard>> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockCards;
  }

  Future<void> toggleLike(String cardId) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.map((card) {
        if (card.id == cardId) {
          return card.copyWith(isLiked: !card.isLiked);
        }
        return card;
      }).toList(),
    );
  }

  /// 매칭을 최종 확정하고 실제 프로필을 연결한다.
  /// 서버에서 UserProfile을 받아온 뒤 해당 카드의 isFinalMatched를 true로 전환.
  Future<void> finalizeMatch(String cardId, UserProfile profile) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.map((card) {
        if (card.id == cardId) {
          return card.copyWith(
            isFinalMatched: true,
            userProfile: profile,
          );
        }
        return card;
      }).toList(),
    );
  }

  /// 매칭 확정된 카드의 실제 프로필을 조회한다.
  /// isFinalMatched == false인 카드는 null을 반환.
  UserProfile? getRevealedProfile(String cardId) {
    final current = state.valueOrNull;
    if (current == null) return null;

    final card = current.where((c) => c.id == cardId).firstOrNull;
    return card?.revealedProfile;
  }
}

final _mockCards = [
  const PersonaCard(
    id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    aiLifestyleReport:
        '균형 잡힌 식단을 통해 건강한 일상을 유지하는 사람입니다. '
        '아침은 간단한 그릭요거트와 과일로 시작하고, '
        '점심은 단백질 중심의 식사를 선호합니다. '
        '저녁에는 직접 요리하며 하루를 마무리하는 루틴이 돋보입니다.',
    personaIndicators: {
      '경제력': 0.72,
      '건강': 0.91,
      '생활 리듬': 0.85,
      '가치관': 0.68,
    },
    primaryNeighborhood: '성수동',
    relativeDistance: 2.3,
  ),
  const PersonaCard(
    id: 'b2c3d4e5-f6a7-8901-bcde-f12345678901',
    aiLifestyleReport:
        '트렌디한 외식을 즐기면서도 자기만의 기준이 확고한 미식가입니다. '
        '새로운 레스토랑 탐방을 좋아하지만, '
        '건강을 위해 주중에는 가벼운 샐러드와 수프를 고집합니다. '
        '음식에 대한 철학이 삶 전반에 반영된 사람입니다.',
    personaIndicators: {
      '경제력': 0.88,
      '건강': 0.75,
      '생활 리듬': 0.62,
      '가치관': 0.93,
    },
    primaryNeighborhood: '연남동',
    relativeDistance: 4.1,
  ),
  const PersonaCard(
    id: 'c3d4e5f6-a7b8-9012-cdef-123456789012',
    aiLifestyleReport:
        '실용적이고 효율적인 식사를 추구하는 사람입니다. '
        '밀프렙을 통해 한 주를 계획적으로 준비하며, '
        '영양 균형을 데이터로 관리하는 체계적인 성향이 엿보입니다. '
        '꾸준함이 이 사람의 가장 큰 강점입니다.',
    personaIndicators: {
      '경제력': 0.55,
      '건강': 0.82,
      '생활 리듬': 0.95,
      '가치관': 0.71,
    },
    primaryNeighborhood: '합정동',
    relativeDistance: 1.8,
  ),
  const PersonaCard(
    id: 'd4e5f6a7-b8c9-0123-defa-234567890123',
    aiLifestyleReport:
        '감성적인 식문화를 즐기며 음식을 통해 사람과 연결되는 타입입니다. '
        '주말 브런치를 소중히 여기고, '
        '계절 식재료에 민감하게 반응합니다. '
        '나눔과 함께하는 식사가 삶의 활력이 되는 사람입니다.',
    personaIndicators: {
      '경제력': 0.65,
      '건강': 0.70,
      '생활 리듬': 0.58,
      '가치관': 0.96,
    },
    primaryNeighborhood: '이태원동',
    relativeDistance: 5.7,
  ),
  const PersonaCard(
    id: 'e5f6a7b8-c9d0-1234-efab-345678901234',
    aiLifestyleReport:
        '운동과 식단을 병행하며 자기 관리에 진심인 사람입니다. '
        '고단백 저탄수 식단을 기본으로 하되, '
        '치팅데이에는 과감하게 즐길 줄 아는 유연함이 있습니다. '
        '건강한 라이프스타일이 자연스럽게 체화된 사람입니다.',
    personaIndicators: {
      '경제력': 0.78,
      '건강': 0.97,
      '생활 리듬': 0.88,
      '가치관': 0.74,
    },
    primaryNeighborhood: '청담동',
    relativeDistance: 3.4,
  ),
];
