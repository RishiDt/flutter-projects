part of 'movie_search_bloc.dart';

sealed class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object> get props => [];
}

final class MovieSearchInitialState extends MovieSearchState {}

final class MovieSearchLoadedState extends MovieSearchState {
  final List<MovieEntity> movies;

  const MovieSearchLoadedState({required this.movies});
}

final class MovieSearchErrorState extends MovieSearchState {}
