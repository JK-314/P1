import 'package:freezed_annotation/freezed_annotation.dart';

import 'persona_category.dart';

part 'persona_entity.freezed.dart';

/// Represents a user's anonymous persona profile.
/// Contains NO personal identifiers — anonymity is enforced at the entity level.
@freezed
class PersonaEntity with _$PersonaEntity {
  const factory PersonaEntity({
    required String id,
    required String userId,
    required Map<PersonaCategory, PersonaCategoryData> categories,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PersonaEntity;
}

@freezed
class PersonaCategoryData with _$PersonaCategoryData {
  const factory PersonaCategoryData({
    required PersonaCategory category,
    required Map<String, dynamic> responses,
    @Default(0.0) double completionRate,
  }) = _PersonaCategoryData;
}
