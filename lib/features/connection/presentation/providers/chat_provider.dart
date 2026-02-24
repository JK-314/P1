import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/user_profile.dart';

part 'chat_provider.g.dart';

const _currentUserId = 'me';
const _uuid = Uuid();

@riverpod
class Chat extends _$Chat {
  @override
  FutureOr<List<ChatMessage>> build(String recipientId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<void> sendMessage(String text) async {
    final current = state.valueOrNull ?? [];
    final message = ChatMessage(
      id: _uuid.v4(),
      senderId: _currentUserId,
      text: text,
      sentAt: DateTime.now(),
    );
    state = AsyncData([...current, message]);

    await Future<void>.delayed(const Duration(milliseconds: 800));

    final reply = ChatMessage(
      id: _uuid.v4(),
      senderId: 'other',
      text: _generateAutoReply(text),
      sentAt: DateTime.now(),
    );
    final updated = state.valueOrNull ?? [];
    state = AsyncData([...updated, reply]);
  }

  String _generateAutoReply(String userMessage) {
    final replies = [
      '안녕하세요! 프로필을 보고 대화해보고 싶었어요 :)',
      '반가워요! 식단 취향이 비슷해서 신기하네요',
      '오늘 점심은 뭐 드셨어요?',
      '저도 브런치 좋아해요! 추천 맛집 있으세요?',
      '건강한 식습관을 가지고 계시네요!',
    ];
    return replies[DateTime.now().millisecond % replies.length];
  }
}

@riverpod
class ChatRecipientProfile extends _$ChatRecipientProfile {
  @override
  FutureOr<UserProfile> build(String recipientId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _mockProfiles[recipientId] ?? _defaultProfile;
  }
}

const _defaultProfile = UserProfile(
  id: 'user-001',
  nickname: '하늘빛 미식가',
  age: 28,
  gender: '여성',
  profileImageUrl:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
  todayFoodKeywords: ['#비건점심', '#와인바', '#브런치카페'],
);

const _mockProfiles = <String, UserProfile>{
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890': _defaultProfile,
};
