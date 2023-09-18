//main bloc class

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/domain/entities/no_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_trending.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
part 'movie_carousal_event.dart';
part 'movie_carousal_state.dart';

class MovieCarousalBloc extends Bloc<MovieCarousalEvent, MovieCarousalState> {
  final GetTrending getTrending;
  final MovieBackdropBloc movieBackdropBloc;

  MovieCarousalBloc(
      {required this.getTrending, required this.movieBackdropBloc})
      : super(MovieCarousalInitial()) {
    on<CarousalLoadEvent>((event, emit) async {
      //sink for state output stream
      final moviesEither = await getTrending(NoParams());
      MovieCarousalState state =
          moviesEither.fold((l) => MovieCarousalError(), (movies) {
        movieBackdropBloc
            .add(MovieBackdropChangedEvent(movies![event.defaultIndex]));
        return MovieCarousalLoaded(
            movies: movies!, defaultIndex: event.defaultIndex);
      });

      emit(state);
      // mapEventToState(
      //   event,
      // );
    });
  }

  // void mapEventToState(
  //     MovieCarousalEvent event, Emitter<MovieCarousalState> emit) async {
  //   if (event is CarousalLoadEvent) {
  //     final moviesEither = await getTrending(NoParams());
  //     moviesEither.fold((l) => MovieCarousalError(), (movies) {
  //       emit(MovieCarousalLoaded(
  //           movies: movies!, defaultIndex: event.defaultIndex));

  //     });
  //   }
  // }

  // Stream<MovieCarousalState> mapEventToState(
  //   MovieCarousalEvent event,
  // ) async* {
  //   if (event is CarousalLoadEvent) {
  //     final moviesEither = await getTrending(NoParams());
  //     yield moviesEither.fold((l) => MovieCarousalError(), (movies) {
  //       return MovieCarousalLoaded(
  //           movies: movies!, defaultIndex: event.defaultIndex);
  //     });
  //   }
  // }
}
