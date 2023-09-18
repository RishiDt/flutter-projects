import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/domain/usecases/use_case.dart';

import '../entities/app_error.dart';
import '../entities/movie_params.dart';
import '../repositories/movie_repository.dart';

class AddMovieToFavorite extends UseCase<void, MovieParams> {
  final MovieRepository movieRepository;

  AddMovieToFavorite(this.movieRepository);

  @override
  Future<Either<AppErr, void>> call(MovieParams movieParams) async {
    //call movieRepo function addMovieToFavorite(movieId) and obtain
    // an Either<AppErr,bool>

    final moviesEither =
        await movieRepository.addMovieToFavorite(movieParams.id);

    late final bool right;

    final status = moviesEither.fold((l) {
      return AppErr(
          message: l.message); //getting AppErr for bloc state if occurs
    }, (status) {
      return status;
    });

    if (status is bool) {
      return Right(status);
    } else {
      return Left(status as AppErr);
    }
  }
}
