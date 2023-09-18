import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:movie_search_flutter_app/domain/entities/cast_entity.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_cast.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_params.dart';

part 'cast_event.dart';
part 'cast_state.dart';

class CastBloc extends Bloc<CastEvent, CastState> {
  final GetCast getCast;
  late final Either<AppErr, List<CastEntity>> castEither;

  CastBloc({required this.getCast}) : super(CastInitialState()) {
    on<CastEvent>(stateEmitter);
  }

  void stateEmitter(CastEvent event, Emitter emit) async {
    if (event is LoadCastEvent) {
      castEither = await getCast(MovieParams(event.movieId));
      CastState state = castEither.fold((l) => CastLoadingErrorState(),
          (casts) => CastLoadedState(casts: casts));

      emit(state);
    }
  }
}
