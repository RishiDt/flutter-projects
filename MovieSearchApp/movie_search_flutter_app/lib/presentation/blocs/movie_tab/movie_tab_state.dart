part of 'movie_tab_bloc.dart';

abstract class MovieTabState extends Equatable {
  final int currentTabIndex;
  const MovieTabState({this.currentTabIndex = 0});

  @override
  List<Object> get props => [];
}

final class MovieTabInitial extends MovieTabState {}

final class MovieTabChangedState extends MovieTabState {
  final List<MovieEntity>? movies;
  const MovieTabChangedState({this.movies, super.currentTabIndex});

  @override
  List<Object> get props => [movies!, currentTabIndex];
}

final class MovieTabErrorState extends MovieTabState {
  const MovieTabErrorState({super.currentTabIndex});
}
