import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// 매칭 확정(Step 3) 후 공개되는 실제 사용자 프로필.
/// PersonaCard.isFinalMatched == true 일 때만 접근 가능.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    /// 실제 닉네임
    required String nickname,

    /// 프로필 사진 URL
    required String profileImageUrl,

    /// 성별
    required String gender,

    /// 나이
    required int age,

    /// 한 줄 자기소개
    required String bio,

    /// 매칭 확정 일시
    required DateTime matchedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
