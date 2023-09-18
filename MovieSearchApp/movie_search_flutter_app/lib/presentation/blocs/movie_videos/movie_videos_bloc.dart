import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_videos.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/video_entity.dart';
import '../cast/cast_bloc.dart';

part 'movie_videos_event.dart';
part 'movie_videos_state.dart';

class MovieVideosBloc extends Bloc<MovieVideosEvent, MovieVideosState> {
  final GetVideos getVideos;
  late final Either<AppErr, List<VideoEntity>> videosEither;

  MovieVideosBloc({required this.getVideos})
      : super(MovieVideosInitialState()) {
    on<MovieVideosEvent>(stateEmitter);
  }

  void stateEmitter(MovieVideosEvent event, Emitter emit) async {
    if (event is LoadMovieVideosEvent) {
      videosEither = await getVideos(MovieParams(event.movieId));

      MovieVideosState state = videosEither.fold(
          (l) => MovieVideosLoadingErrorState(),
          (videos) => MovieVideosLoadedState(videos: videos));

      emit(state);
    }
  }
}
