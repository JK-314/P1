import '../models/match_model.dart';

/// Simulates Supabase Row Level Security (RLS) policies for match data.
///
/// RLS rules enforced:
///  - A user can only update their own acceptance column.
///  - Profile photo URLs are only accessible when isFinalMatched is true.
///    Requesting a photo URL before final match returns an [RlsException].
class RlsException implements Exception {
  final String message;
  const RlsException(this.message);

  @override
  String toString() => 'RlsException: $message';
}

class MatchRepository {
  /// In-memory store keyed by match id, simulating a Supabase `matches` table.
  final Map<String, MatchModel> _store = {};

  /// Simulated profile photo table – only readable when RLS allows it.
  final Map<String, String> _profilePhotos = {};

  static const String anonymousPhotoUrl =
      'https://storage.example.com/defaults/anonymous_avatar.png';

  // ---------------------------------------------------------------------------
  // CRUD helpers
  // ---------------------------------------------------------------------------

  /// Seeds a pending match between two users. Returns the created match.
  MatchModel createMatch({
    required String matchId,
    required String userId,
    required String targetUserId,
  }) {
    final match = MatchModel(
      id: matchId,
      userId: userId,
      targetUserId: targetUserId,
      createdAt: DateTime.now(),
    );
    _store[matchId] = match;
    return match;
  }

  /// Registers a profile photo for a user (admin-level, bypasses RLS).
  void seedProfilePhoto(String userId, String photoUrl) {
    _profilePhotos[userId] = photoUrl;
  }

  MatchModel? getMatch(String matchId) => _store[matchId];

  /// Finds the match record between [userId] and [targetUserId] regardless of
  /// column order (user ↔ target).
  MatchModel? findMatchBetween(String userId, String targetUserId) {
    return _store.values.cast<MatchModel?>().firstWhere(
          (m) =>
              (m!.userId == userId && m.targetUserId == targetUserId) ||
              (m.userId == targetUserId && m.targetUserId == userId),
          orElse: () => null,
        );
  }

  // ---------------------------------------------------------------------------
  // Accept logic – simulates Supabase RLS column-level write restriction
  // ---------------------------------------------------------------------------

  /// Records acceptance for [actingUserId] on match [matchId].
  ///
  /// RLS policy: a user may only flip **their own** accepted flag.
  /// Returns the updated [MatchModel].
  MatchModel acceptMatch({
    required String matchId,
    required String actingUserId,
  }) {
    final match = _store[matchId];
    if (match == null) {
      throw RlsException('Match $matchId not found');
    }

    final bool isUser = match.userId == actingUserId;
    final bool isTarget = match.targetUserId == actingUserId;

    if (!isUser && !isTarget) {
      throw RlsException(
        'RLS violation: $actingUserId is not a participant of match $matchId',
      );
    }

    MatchModel updated;
    if (isUser) {
      updated = match.copyWith(userAccepted: true);
    } else {
      updated = match.copyWith(targetAccepted: true);
    }

    if (updated.isFinalMatched) {
      updated = updated.copyWith(finalMatchedAt: DateTime.now());
    }

    _store[matchId] = updated;
    return updated;
  }

  // ---------------------------------------------------------------------------
  // Profile photo access – simulates Supabase RLS read restriction
  // ---------------------------------------------------------------------------

  /// Returns the profile photo URL of [targetUserId] **only if** the match
  /// identified by [matchId] has reached final-match status.
  ///
  /// Supabase RLS equivalent:
  /// ```sql
  /// CREATE POLICY "Allow photo read only when final matched"
  ///   ON profile_photos FOR SELECT
  ///   USING (
  ///     EXISTS (
  ///       SELECT 1 FROM matches
  ///       WHERE matches.id = profile_photos.match_id
  ///         AND matches.is_final_matched = true
  ///         AND (matches.user_id = auth.uid() OR matches.target_user_id = auth.uid())
  ///     )
  ///   );
  /// ```
  String getProfilePhotoUrl({
    required String matchId,
    required String requestingUserId,
    required String targetUserId,
  }) {
    final match = _store[matchId];
    if (match == null) {
      throw RlsException('Match $matchId not found');
    }

    final isParticipant = match.userId == requestingUserId ||
        match.targetUserId == requestingUserId;
    if (!isParticipant) {
      throw RlsException(
        'RLS violation: $requestingUserId is not a participant of match $matchId',
      );
    }

    if (!match.isFinalMatched) {
      throw RlsException(
        'RLS violation: profile photo access denied – match is not finalized. '
        'Returning anonymous avatar instead.',
      );
    }

    return _profilePhotos[targetUserId] ?? anonymousPhotoUrl;
  }

  /// Safe variant that never throws – returns the anonymous avatar when RLS
  /// would block access.
  String getProfilePhotoUrlSafe({
    required String matchId,
    required String requestingUserId,
    required String targetUserId,
  }) {
    try {
      return getProfilePhotoUrl(
        matchId: matchId,
        requestingUserId: requestingUserId,
        targetUserId: targetUserId,
      );
    } on RlsException {
      return anonymousPhotoUrl;
    }
  }
}
