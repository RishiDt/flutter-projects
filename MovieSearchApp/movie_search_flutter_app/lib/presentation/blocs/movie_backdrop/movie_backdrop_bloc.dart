//internally used at MovieCarousalBloc and MovieCourousalWidget

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';

part 'movie_backdrop_event.dart';
part 'movie_backdrop_state.dart';

class MovieBackdropBloc extends Bloc<MovieBackdropEvent, MovieBackdropState> {
  MovieBackdropBloc() : super(MovieBackdropInitialState()) {
    on<MovieBackdropChangedEvent>((event, emit) {
      emit(MovieBackdropChangedState(event.movie));
    });
  }
}
