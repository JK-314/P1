import 'package:flutter/foundation.dart';

import '../../data/models/match_model.dart';
import '../../data/repositories/match_repository.dart';

/// Manages match state and exposes actions to the UI layer.
///
/// Key behaviour:
///  - [acceptFinalMatch] lets the current user accept a match.
///    `isFinalMatched` becomes `true` **only** when both participants accept.
///  - [getTargetProfilePhotoUrl] enforces Supabase RLS simulation:
///    before final match the URL is the anonymous default; after final match
///    the real photo URL is returned.
class MatchProvider extends ChangeNotifier {
  final MatchRepository _repository;
  final String _currentUserId;

  MatchModel? _currentMatch;
  String? _errorMessage;
  bool _isLoading = false;

  MatchProvider({
    required MatchRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  MatchModel? get currentMatch => _currentMatch;
  bool get isFinalMatched => _currentMatch?.isFinalMatched ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentUserId => _currentUserId;

  /// Whether the **current user** has already accepted this match.
  bool get hasCurrentUserAccepted {
    final m = _currentMatch;
    if (m == null) return false;
    if (m.userId == _currentUserId) return m.userAccepted;
    if (m.targetUserId == _currentUserId) return m.targetAccepted;
    return false;
  }

  /// Whether the **other** participant has already accepted.
  bool get hasTargetAccepted {
    final m = _currentMatch;
    if (m == null) return false;
    if (m.userId == _currentUserId) return m.targetAccepted;
    if (m.targetUserId == _currentUserId) return m.userAccepted;
    return false;
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Loads (or creates) the match between the current user and [targetUserId].
  void loadMatch(String targetUserId) {
    _errorMessage = null;
    _currentMatch =
        _repository.findMatchBetween(_currentUserId, targetUserId);
    notifyListeners();
  }

  /// Records the current user's acceptance of the match with [targetUserId].
  ///
  /// **Both** participants must call this (each from their own session) for
  /// [isFinalMatched] to become `true`.
  ///
  /// Flow:
  ///  1. Look up (or fail on) the existing match record.
  ///  2. Delegate to [MatchRepository.acceptMatch] which enforces RLS rules.
  ///  3. Update local state and notify listeners.
  ///
  /// After a successful call:
  ///  - If only the current user accepted → [isFinalMatched] remains `false`.
  ///  - If **both** users accepted → [isFinalMatched] becomes `true` and
  ///    profile photos become accessible.
  void acceptFinalMatch(String targetUserId) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Resolve the match record between the two users.
      var match =
          _repository.findMatchBetween(_currentUserId, targetUserId);

      if (match == null) {
        throw const RlsException('No pending match found between the users');
      }

      // Delegate acceptance – repository enforces RLS (only own column).
      final updated = _repository.acceptMatch(
        matchId: match.id,
        actingUserId: _currentUserId,
      );

      _currentMatch = updated;
      _errorMessage = null;
    } on RlsException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Returns the profile photo URL of the match target.
  ///
  /// Simulates Supabase RLS:
  ///  - **Before final match**: returns the anonymous default avatar.
  ///  - **After final match**: returns the real profile photo URL.
  ///
  /// This mirrors a real RLS policy that restricts `SELECT` on the
  /// `profile_photos` table to rows where the related match is finalized.
  String getTargetProfilePhotoUrl(String targetUserId) {
    final match = _currentMatch;
    if (match == null) {
      return MatchRepository.anonymousPhotoUrl;
    }

    return _repository.getProfilePhotoUrlSafe(
      matchId: match.id,
      requestingUserId: _currentUserId,
      targetUserId: targetUserId,
    );
  }

  /// Strict variant – throws [RlsException] instead of falling back to the
  /// anonymous avatar. Useful for UI flows that want to show an explicit error
  /// dialog when access is denied.
  String getTargetProfilePhotoUrlStrict(String targetUserId) {
    final match = _currentMatch;
    if (match == null) {
      throw const RlsException(
        'No active match – cannot access profile photo',
      );
    }

    return _repository.getProfilePhotoUrl(
      matchId: match.id,
      requestingUserId: _currentUserId,
      targetUserId: targetUserId,
    );
  }
}
