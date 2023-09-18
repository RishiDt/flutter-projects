import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/add_movie_to_favorite.dart';

import '../../../domain/usecases/remove_movie_from_favorite.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AddMovieToFavorite addMovieToFavorite;
  final RemoveMovieFromFavorite removeMovieFromFavorite;

  UserBloc(
      {required this.addMovieToFavorite, required this.removeMovieFromFavorite})
      : super(UserInitialState()) {
    on<AddMovieToFavoriteEvent>(AddMovieToFavoriteEventHandler);
    on<RemoveMovieFromFavoriteEvent>(removeMovieFromFavoriteEventHandler);
  }

  void AddMovieToFavoriteEventHandler(
      AddMovieToFavoriteEvent event, Emitter emit) async {
    //get movieid from event and hit use case addTofav
    //which will return bool or AppErr
    final statusEither = await addMovieToFavorite(MovieParams(event.movieId));
    final state = statusEither.fold((l) {
      //incase of any error AppErr.message msg will be printed
      print(l.message);
      print("error captured in userbloc");
      return UserOpErrorState();
    }, (status) => UserOpSucceededState());

    print("userbloc state is ${state}");

    emit(state);
  }

  void removeMovieFromFavoriteEventHandler(
      RemoveMovieFromFavoriteEvent event, Emitter emit) async {
    //get movieid from event and hit use case addTofav
    //which will return bool or AppErr
    final statusEither =
        await removeMovieFromFavorite(MovieParams(event.movieId));
    final state = statusEither.fold((l) {
      //incase of any error AppErr.message msg will be printed
      print(l.message);
      print("error captured in userbloc");
      return UserOpErrorState();
    }, (status) => UserOpSucceededState());

    print("userbloc state is ${state}");

    emit(state);
  }
}
