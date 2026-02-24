import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Step 3에서 공개되는 실제 사용자 프로필.
/// 상호 동의(mutual consent) 후에만 접근 가능.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String nickname,
    required int age,
    required String gender,
    required String profileImageUrl,

    /// 오늘의 식단 키워드 태그 (채팅 상단에 표시)
    @Default([]) List<String> todayFoodKeywords,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
