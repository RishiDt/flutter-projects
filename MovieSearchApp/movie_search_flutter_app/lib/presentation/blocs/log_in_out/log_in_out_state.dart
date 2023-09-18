part of 'log_in_out_bloc.dart';

sealed class LogInOutState extends Equatable {
  const LogInOutState();

  @override
  List<Object> get props => [];
}

final class LogInOutInitialState extends LogInOutState {}

final class LogInSuccessState extends LogInOutState {}

final class LogOutSuccesState extends LogInOutState {}

final class LogInErrorState extends LogInOutState {
  final String? message;
  const LogInErrorState({required this.message});
  @override
  List<Object> get props => [message!];
}

final class LogOutErrorState extends LogInErrorState {
  LogOutErrorState({required super.message});
}
