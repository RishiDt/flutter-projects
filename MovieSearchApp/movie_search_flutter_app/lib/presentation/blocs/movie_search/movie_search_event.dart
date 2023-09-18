part of 'movie_search_bloc.dart';

sealed class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchMovieEvent extends MovieSearchEvent {
  final String searchQuery;

  const SearchMovieEvent({required this.searchQuery});
}

class ResetEvent extends MovieSearchEvent {}
