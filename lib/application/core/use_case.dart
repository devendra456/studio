import 'package:dartz/dartz.dart';

import 'failure.dart';

mixin UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
