import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_detail_entity.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/check_if_movie_favorite.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_movie_detail.dart';
import 'package:movie_search_flutter_app/presentation/blocs/cast/cast_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_videos/movie_videos_bloc.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_entity.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final CastBloc castBloc;
  final MovieVideosBloc videosBloc;
  final CheckIfFavoriteMovie checkIfFavoriteMovie;
  late final Either<AppErr, MovieDetailEntity> movieDetailEither;
  MovieDetailBloc(
      {required this.getMovieDetail,
      required this.castBloc,
      required this.videosBloc,
      required this.checkIfFavoriteMovie})
      : super(MovieDetailInitialState()) {
    on<MovieDetailEvent>(stateEmitter);
  }

  void stateEmitter(MovieDetailEvent event, Emitter emit) async {
    if (event is MovieDetailLoadEvent) {
      //obtaining MovieEntity
      movieDetailEither = await getMovieDetail(MovieParams(event.movieId));

      //checking if movie is favorite
      final isMovieFavEither =
          await checkIfFavoriteMovie(MovieParams(event.movieId));

      //sending cast event
      castBloc.add(LoadCastEvent(movieId: event.movieId));

      //sending loadVideos event
      videosBloc.add(LoadMovieVideosEvent(movieId: event.movieId));

      MovieDetailState state = movieDetailEither.fold(
          (l) => MovieDetailErrorState(),
          (movie) => MovieDetailLoadedState(
              movie: movie,
              isFav: isMovieFavEither.fold((l) {
                print(l.message);
                return false; //sending false to isFav for error
              }, (r) => r)));

      print(
          "movie detail load event fired and state.isFav is ${state.props[1]}");

      emit(state);
    }
  }
}
