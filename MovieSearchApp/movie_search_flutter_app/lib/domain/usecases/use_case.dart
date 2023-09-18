import 'package:dartz/dartz.dart';

import '../entities/app_error.dart';
import '../entities/movie_entity.dart';

abstract class UseCase<Type, Params> {
  Future<Either<AppErr, Type>> call(Params params);
}
