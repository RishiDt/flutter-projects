part of 'movie_backdrop_bloc.dart';

sealed class MovieBackdropState extends Equatable {
  const MovieBackdropState();

  @override
  List<Object> get props => [];
}

final class MovieBackdropInitialState extends MovieBackdropState {}

final class MovieBackdropErrorState extends MovieBackdropState {}

final class MovieBackdropChangedState extends MovieBackdropState {
  final MovieEntity movie;
  const MovieBackdropChangedState(this.movie);

  @override
  List<Object> get props => [movie];
}
