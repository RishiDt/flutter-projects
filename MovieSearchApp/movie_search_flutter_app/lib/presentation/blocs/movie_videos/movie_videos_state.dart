part of 'movie_videos_bloc.dart';

sealed class MovieVideosState extends Equatable {
  const MovieVideosState();

  @override
  List<Object> get props => [];
}

final class MovieVideosInitialState extends MovieVideosState {}

final class MovieVideosLoadedState extends MovieVideosState {
  final List<VideoEntity> videos;

  const MovieVideosLoadedState({required this.videos});
}

final class MovieVideosLoadingErrorState extends MovieVideosState {}
