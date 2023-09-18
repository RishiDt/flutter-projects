import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/domain/usecases/use_case.dart';

import '../entities/app_error.dart';
import '../entities/movie_params.dart';
import '../repositories/movie_repository.dart';

class CheckIfFavoriteMovie extends UseCase<bool, MovieParams> {
  final MovieRepository movieRepository;

  CheckIfFavoriteMovie(this.movieRepository);

  @override
  Future<Either<AppErr, bool>> call(MovieParams movieParams) async {
    final moviesEither = await movieRepository.getFavorites();

    late final bool right;

    final isFav = moviesEither.fold((l) {
      return AppErr(
          message: l.message); //getting AppErr for bloc state if occurs
    }, (movies) {
      right = movies!.contains(movieParams.id.toString());

      print("movie with id ${movieParams.id} has fav status: ${right}");

      //getting isFav of loaded state for movie detail
      return right;
    });

    if (isFav is bool) {
      return Right(isFav);
    } else {
      return Left(isFav as AppErr);
    }
  }
}
