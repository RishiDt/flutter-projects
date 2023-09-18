part of 'cast_bloc.dart';

sealed class CastState extends Equatable {
  const CastState();

  @override
  List<Object> get props => [];
}

final class CastInitialState extends CastState {}

final class CastLoadedState extends CastState {
  final List<CastEntity> casts;

  const CastLoadedState({required this.casts});

  @override
  List<Object> get props => [casts];
}

final class CastLoadingErrorState extends CastState {}
