import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:movie_search_flutter_app/domain/entities/login_request_params.dart';
import 'package:movie_search_flutter_app/domain/entities/no_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/login_user.dart';
import 'package:movie_search_flutter_app/domain/usecases/logout_user.dart';
import 'package:movie_search_flutter_app/domain/usecases/resume_login.dart';

part 'log_in_out_event.dart';
part 'log_in_out_state.dart';

class LogInOutBloc extends Bloc<LogInOutEvent, LogInOutState> {
  LoginUser loginUser;
  LogoutUser logoutUser;
  ResumeLogin resumeLogin;
  LogInOutBloc(
      {required this.loginUser,
      required this.logoutUser,
      required this.resumeLogin})
      : super(LogInOutInitialState()) {
    on<LogInEvent>(stateEmitter);
    on<LogOutEvent>(logOutEventHandler);
    on<ResumelogInEvent>(resumeLoginEventHandler);
  }

  void stateEmitter(LogInOutEvent event, Emitter emit) async {
    if (event is LogInEvent) {
      final statusEither = await loginUser(LoginRequestParams(
          userName: event.params.userName, password: event.params.password));

      LogInOutState state = statusEither.fold(
        (l) => LogInErrorState(message: l.message),
        (status) {
          return status
              ? LogInSuccessState()
              : const LogInErrorState(message: "status for login is false");
        },
      );
      emit(state);
    }
  }

  void logOutEventHandler(LogInOutEvent event, Emitter emit) async {
    if (event is LogOutEvent) {
      print("logoutevent occured");
      final logOutStatusEither = await logoutUser(NoParams());
      final state = logOutStatusEither.fold(
          (l) => LogOutErrorState(message: l.message),
          (r) => LogOutSuccesState());
      print("newly created state is ${state}");
      emit(state);
    }
  }

  void resumeLoginEventHandler(ResumelogInEvent event, Emitter emit) async {
    print("Resume login event fired");

    final resumeLoginStatusEither = await resumeLogin(NoParams());

    final state = resumeLoginStatusEither.fold(
        (l) => LogInErrorState(message: l.message), (r) => LogInSuccessState());

    emit(state);
  }
}
