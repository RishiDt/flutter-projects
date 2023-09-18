part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitialState extends UserState {}

final class UserOpSucceededState extends UserState {}

final class UserOpErrorState extends UserState {}
