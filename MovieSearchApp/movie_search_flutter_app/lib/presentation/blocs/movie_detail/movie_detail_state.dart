part of 'movie_detail_bloc.dart';

sealed class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

final class MovieDetailInitialState extends MovieDetailState {}

final class MovieDetailLoadingState extends MovieDetailState {}

final class MovieDetailLoadedState extends MovieDetailState {
  final MovieDetailEntity movie;
  final bool isFav;
  const MovieDetailLoadedState({required this.movie, required this.isFav});
  @override
  List<Object> get props => [movie, isFav];
}

final class MovieDetailErrorState extends MovieDetailState {}
