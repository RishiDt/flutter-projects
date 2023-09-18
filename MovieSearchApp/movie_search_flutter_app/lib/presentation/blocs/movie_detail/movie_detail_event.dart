part of 'movie_detail_bloc.dart';

sealed class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
}

class MovieDetailLoadEvent extends MovieDetailEvent {
  final int movieId;
  const MovieDetailLoadEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
