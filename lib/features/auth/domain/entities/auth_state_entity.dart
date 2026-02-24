import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state_entity.freezed.dart';

/// Auth state entity. Only stores minimal auth info.
/// Personal details (name, age, photo) are never part of auth state.
@freezed
class AuthStateEntity with _$AuthStateEntity {
  const factory AuthStateEntity.authenticated({
    required String userId,
    required String email,
  }) = Authenticated;

  const factory AuthStateEntity.unauthenticated() = Unauthenticated;

  const factory AuthStateEntity.loading() = AuthLoading;
}
