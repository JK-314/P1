import 'package:fpdart/fpdart.dart';

import 'failure.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> execute(Params params);
}

abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> execute();
}

class NoParams {
  const NoParams();
}
