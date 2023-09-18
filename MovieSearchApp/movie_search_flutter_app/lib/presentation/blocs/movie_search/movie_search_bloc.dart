import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_flutter_app/data/models/movie_model.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_search_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/search_movie.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_detail_entity.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  SearchMovie searchMovie;

  MovieSearchBloc({required this.searchMovie})
      : super(MovieSearchInitialState()) {
    on<MovieSearchEvent>(stateEmitter);
    on<ResetEvent>(
      (event, emit) {
        emit(MovieSearchInitialState());
      },
    );
  }
  void stateEmitter(MovieSearchEvent event, Emitter emit) async {
    if (event is SearchMovieEvent) {
      final resultEither =
          await searchMovie(MovieSearchParams(searchTerm: event.searchQuery));
      MovieSearchState state = resultEither.fold(
        (l) => MovieSearchErrorState(),
        (movies) {
          var state = MovieSearchLoadedState(movies: movies);
          print(
              "MovieSearchLoadedState is  set here are the movies: ${state.movies}");
          return state;
        },
      );
      emit(state);
    }
  }
}
