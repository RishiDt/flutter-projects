import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/domain/repositories/movie_repository.dart';
import 'package:movie_search_flutter_app/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/domain/usecases/use_case.dart';

import '../entities/no_params.dart';

class GetPopular extends UseCase<List<MovieEntity>?, NoParams> {
  final MovieRepository moviesRepo;

  GetPopular({required this.moviesRepo});

  @override
  Future<Either<AppErr, List<MovieEntity>?>> call(NoParams noParams) async {
    return moviesRepo.getPolpular();
  }
}
