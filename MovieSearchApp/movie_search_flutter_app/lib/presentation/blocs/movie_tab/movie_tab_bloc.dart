import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:movie_search_flutter_app/domain/entities/app_error.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/domain/entities/no_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_coming_soon.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_playing_now.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_popular.dart';

part 'movie_tab_event.dart';
part 'movie_tab_state.dart';

class MovieTabBloc extends Bloc<MovieTabEvent, MovieTabState> {
  GetComingSoon getComingSoon;
  GetPlayingNow getPlayingNow;
  GetPopular getPopular;
  late Either<AppErr, List<MovieEntity>?> moviesEither;

  MovieTabBloc(
      {required this.getComingSoon,
      required this.getPlayingNow,
      required this.getPopular})
      : super(MovieTabInitial()) {
    on<MovieTabEvent>(stateEmitter);
  }

  void stateEmitter(MovieTabEvent event, Emitter emit) async {
    if (event is MovieTabChangedEvent) {
      switch (event.currentTabIndex) {
        case 0:
          moviesEither = await getPopular(NoParams());
          break;
        case 1:
          moviesEither = await getPlayingNow(NoParams());
          break;
        case 2:
          moviesEither = await getComingSoon(NoParams());
          break;
      }

      MovieTabState state = moviesEither.fold(
          (l) => MovieTabErrorState(currentTabIndex: event.currentTabIndex),
          (movies) => MovieTabChangedState(
              movies: movies, currentTabIndex: event.currentTabIndex));

      emit(state);
    }
  }
}
