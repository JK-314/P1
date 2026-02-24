import 'package:flutter_test/flutter_test.dart';

import 'package:p1/data/models/match_model.dart';
import 'package:p1/data/repositories/match_repository.dart';
import 'package:p1/presentation/providers/match_provider.dart';

void main() {
  late MatchRepository repository;

  const userA = 'user-a';
  const userB = 'user-b';
  const matchId = 'match-001';
  const realPhotoUrl = 'https://storage.example.com/photos/user-b.jpg';

  setUp(() {
    repository = MatchRepository();
    repository.createMatch(
      matchId: matchId,
      userId: userA,
      targetUserId: userB,
    );
    repository.seedProfilePhoto(userB, realPhotoUrl);
  });

  group('acceptFinalMatch', () {
    test('single-side acceptance does NOT finalize the match', () {
      final provider = MatchProvider(
        repository: repository,
        currentUserId: userA,
      );

      provider.loadMatch(userB);
      expect(provider.isFinalMatched, isFalse);

      provider.acceptFinalMatch(userB);

      expect(provider.hasCurrentUserAccepted, isTrue);
      expect(provider.hasTargetAccepted, isFalse);
      expect(provider.isFinalMatched, isFalse);
      expect(provider.errorMessage, isNull);
    });

    test('both sides accepting finalizes the match', () {
      final providerA = MatchProvider(
        repository: repository,
        currentUserId: userA,
      );
      final providerB = MatchProvider(
        repository: repository,
        currentUserId: userB,
      );

      providerA.loadMatch(userB);
      providerA.acceptFinalMatch(userB);
      expect(providerA.isFinalMatched, isFalse);

      providerB.loadMatch(userA);
      providerB.acceptFinalMatch(userA);
      expect(providerB.isFinalMatched, isTrue);

      // Provider A should see the updated state after reload.
      providerA.loadMatch(userB);
      expect(providerA.isFinalMatched, isTrue);
    });

    test('accepting a non-existent match sets errorMessage', () {
      final provider = MatchProvider(
        repository: repository,
        currentUserId: userA,
      );

      provider.acceptFinalMatch('unknown-user');

      expect(provider.isFinalMatched, isFalse);
      expect(provider.errorMessage, isNotNull);
    });
  });

  group('RLS profile photo simulation', () {
    test('returns anonymous avatar before final match', () {
      final provider = MatchProvider(
        repository: repository,
        currentUserId: userA,
      );

      provider.loadMatch(userB);
      provider.acceptFinalMatch(userB);

      // Only user A accepted – not finalized yet.
      final url = provider.getTargetProfilePhotoUrl(userB);
      expect(url, equals(MatchRepository.anonymousPhotoUrl));
    });

    test('returns real photo URL after final match', () {
      final providerA = MatchProvider(
        repository: repository,
        currentUserId: userA,
      );
      final providerB = MatchProvider(
        repository: repository,
        currentUserId: userB,
      );

      providerA.loadMatch(userB);
      providerA.acceptFinalMatch(userB);

      providerB.loadMatch(userA);
      providerB.acceptFinalMatch(userA);

      // Both accepted → finalized.
      providerA.loadMatch(userB);
      final url = providerA.getTargetProfilePhotoUrl(userB);
      expect(url, equals(realPhotoUrl));
    });

    test('strict variant throws RlsException before final match', () {
      final provider = MatchProvider(
        repository: repository,
        currentUserId: userA,
      );

      provider.loadMatch(userB);

      expect(
        () => provider.getTargetProfilePhotoUrlStrict(userB),
        throwsA(isA<RlsException>()),
      );
    });
  });
}
