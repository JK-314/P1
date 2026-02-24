import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_entity.freezed.dart';

/// Represents a completed connection after mutual consent in Step 3.
@freezed
class ConnectionEntity with _$ConnectionEntity {
  const factory ConnectionEntity({
    required String id,
    required String matchId,
    required String userAId,
    required String userBId,
    required DateTime connectedAt,
    @Default({}) Map<String, bool> revealedFields,
  }) = _ConnectionEntity;
}
