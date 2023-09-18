part of 'log_in_out_bloc.dart';

sealed class LogInOutEvent extends Equatable {
  const LogInOutEvent();

  @override
  List<Object> get props => [];
}

class LogInEvent extends LogInOutEvent {
  final LoginRequestParams params;
  const LogInEvent({required this.params});
}

class LogOutEvent extends LogInOutEvent {}

class ResumelogInEvent extends LogInOutEvent {}
