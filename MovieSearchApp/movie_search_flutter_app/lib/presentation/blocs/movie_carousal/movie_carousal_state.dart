//state classes  for carousal bloc

part of 'movie_carousal_bloc.dart';

sealed class MovieCarousalState extends Equatable {
  const MovieCarousalState();

  @override
  List<Object> get props => [];
}

final class MovieCarousalInitial extends MovieCarousalState {}

final class MovieCarousalError extends MovieCarousalState {}

final class MovieCarousalLoaded extends MovieCarousalState {
  final List<MovieEntity> movies;
  final int defaultIndex;

  const MovieCarousalLoaded({required this.movies, required this.defaultIndex})
      : assert(defaultIndex >= 0, 'defaultIndex cant be less than 0');

  @override
  List<Object> get props => [movies, defaultIndex];
}
