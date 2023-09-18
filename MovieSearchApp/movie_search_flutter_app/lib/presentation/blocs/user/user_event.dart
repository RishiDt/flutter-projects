part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class AddMovieToFavoriteEvent extends UserEvent {
  final int movieId;

  const AddMovieToFavoriteEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class RemoveMovieFromFavoriteEvent extends UserEvent {
  final int movieId;

  const RemoveMovieFromFavoriteEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
