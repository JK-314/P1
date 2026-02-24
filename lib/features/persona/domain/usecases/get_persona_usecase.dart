import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/persona_entity.dart';

abstract class PersonaRepository {
  Future<Either<Failure, PersonaEntity>> getPersona(String userId);
  Future<Either<Failure, PersonaEntity>> updatePersona(PersonaEntity persona);
  Future<Either<Failure, PersonaEntity>> createPersona(String userId);
}

class GetPersonaUseCase extends UseCase<PersonaEntity, String> {
  GetPersonaUseCase(this._repository);

  final PersonaRepository _repository;

  @override
  Future<Either<Failure, PersonaEntity>> execute(String userId) {
    return _repository.getPersona(userId);
  }
}
