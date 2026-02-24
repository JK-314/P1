import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/chat_provider.dart';

const _currentUserId = 'me';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.recipientId,
  });

  final String recipientId;

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showHint = true;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() => _showHint = false);

    ref.read(chatProvider(widget.recipientId).notifier).sendMessage(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncProfile =
        ref.watch(chatRecipientProfileProvider(widget.recipientId));
    final asyncMessages = ref.watch(chatProvider(widget.recipientId));
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: FoodFeedColors.offWhite,
      body: Column(
        children: [
          asyncProfile.when(
            data: (profile) => _ChatAppBar(profile: profile),
            loading: () => const _ChatAppBarSkeleton(),
            error: (_, __) => const _ChatAppBarSkeleton(),
          ),

          // Messages
          Expanded(
            child: asyncMessages.when(
              data: (messages) => messages.isEmpty && _showHint
                  ? _EmptyChatHint(
                      recipientName: asyncProfile.valueOrNull?.nickname ?? '',
                    )
                  : _MessageList(
                      messages: messages,
                      scrollController: _scrollController,
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: FoodFeedColors.deepGreenSoft,
                ),
              ),
              error: (_, __) => const Center(
                child: Text('메시지를 불러올 수 없습니다'),
              ),
            ),
          ),

          // Input
          _ChatInput(
            controller: _textController,
            onSend: _sendMessage,
            bottomPadding: bottomInset > 0 ? 0 : bottomPadding,
          ),
        ],
      ),
    );
  }
}

// ─── App Bar with food keyword status ───

class _ChatAppBar extends StatelessWidget {
  const _ChatAppBar({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: FoodFeedColors.darkText.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main bar
          SizedBox(
            height: 56,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: FoodFeedColors.darkText,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FoodFeedColors.cream,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      profile.profileImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: FoodFeedColors.cream,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 20,
                          color: FoodFeedColors.warmGray,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.nickname,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: FoodFeedColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${profile.age}세 · ${profile.gender}',
                        style: textTheme.labelSmall?.copyWith(
                          color: FoodFeedColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: FoodFeedColors.warmGray,
                  ),
                ),
              ],
            ),
          ),

          // Food keyword status bar
          if (profile.todayFoodKeywords.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: FoodFeedColors.cream.withValues(alpha: 0.6),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                      size: 13,
                      color: FoodFeedColors.deepGreenSoft.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "오늘의 키워드",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: FoodFeedColors.mutedText.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...profile.todayFoodKeywords.map((keyword) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: FoodFeedColors.tagBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            keyword,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: FoodFeedColors.tagText,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatAppBarSkeleton extends StatelessWidget {
  const _ChatAppBarSkeleton();

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 56 + topPadding,
      padding: EdgeInsets.only(top: topPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: FoodFeedColors.darkText.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: FoodFeedColors.darkText,
            ),
          ),
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: FoodFeedColors.deepGreenSoft,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty Chat Hint ───

class _EmptyChatHint extends StatelessWidget {
  const _EmptyChatHint({required this.recipientName});

  final String recipientName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: FoodFeedColors.tagBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.waving_hand_rounded,
                size: 32,
                color: FoodFeedColors.accentAmber,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '첫 인사를 건네보세요!',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: FoodFeedColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recipientName.isNotEmpty
                  ? '$recipientName님과의 대화를 시작해보세요.\n식단 취향에 대한 이야기로 시작하면 좋아요!'
                  : '식단 취향에 대한 이야기로\n대화를 시작해보세요!',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: FoodFeedColors.mutedText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _SuggestionChip(label: '오늘 점심 뭐 드셨어요?'),
                _SuggestionChip(label: '좋아하는 음식이 뭐예요?'),
                _SuggestionChip(label: '맛집 추천해주세요!'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: FoodFeedColors.cream,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: FoodFeedColors.mutedText,
        ),
      ),
    );
  }
}

// ─── Message List ───

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messages,
    required this.scrollController,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == _currentUserId;
        final showTimestamp = index == messages.length - 1 ||
            messages[index + 1].sentAt.difference(message.sentAt).inMinutes > 5;

        return _MessageBubble(
          message: message,
          isMe: isMe,
          showTimestamp: showTimestamp,
        );
      },
    );
  }
}

// ─── Message Bubble ───

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.showTimestamp,
  });

  final ChatMessage message;
  final bool isMe;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe && showTimestamp) ...[
                Text(
                  _formatTime(message.sentAt),
                  style: textTheme.labelSmall?.copyWith(
                    color: FoodFeedColors.mutedText.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? FoodFeedColors.deepGreen : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: FoodFeedColors.darkText.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isMe ? Colors.white : FoodFeedColors.darkText,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (!isMe && showTimestamp) ...[
                const SizedBox(width: 6),
                Text(
                  _formatTime(message.sentAt),
                  style: textTheme.labelSmall?.copyWith(
                    color: FoodFeedColors.mutedText.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$period $displayHour:$minute';
  }
}

// ─── Chat Input ───

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.onSend,
    required this.bottomPadding,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 8, 8 + bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: FoodFeedColors.darkText.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: FoodFeedColors.offWhite,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                style: const TextStyle(
                  fontSize: 15,
                  color: FoodFeedColors.darkText,
                ),
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  hintStyle: TextStyle(
                    color: FoodFeedColors.mutedText.withValues(alpha: 0.5),
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: FoodFeedColors.deepGreen,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              onTap: onSend,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
