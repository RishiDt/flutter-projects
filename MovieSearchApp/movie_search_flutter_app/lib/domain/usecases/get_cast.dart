import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/domain/usecases/use_case.dart';

import '../entities/app_error.dart';
import '../entities/cast_entity.dart';
import '../entities/movie_params.dart';
import '../repositories/movie_repository.dart';

class GetCast extends UseCase<List<CastEntity>, MovieParams> {
  final MovieRepository repository;

  GetCast(this.repository);

  @override
  Future<Either<AppErr, List<CastEntity>>> call(MovieParams movieParams) async {
    return await repository.getCastCrew(movieParams.id);
  }
}
