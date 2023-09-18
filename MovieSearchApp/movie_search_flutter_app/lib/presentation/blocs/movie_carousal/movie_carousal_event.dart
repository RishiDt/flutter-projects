//event classes for carousal bloc

part of 'movie_carousal_bloc.dart';

sealed class MovieCarousalEvent extends Equatable {
  const MovieCarousalEvent();

  @override
  List<Object> get props => [];
}

class CarousalLoadEvent extends MovieCarousalEvent {
  final int defaultIndex;

  const CarousalLoadEvent({this.defaultIndex = 0})
      : assert(defaultIndex >= 0, 'defualtIndex cannot be less than 0');
}
