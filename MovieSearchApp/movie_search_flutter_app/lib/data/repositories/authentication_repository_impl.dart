// import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/data/data_source/shared_prefernces.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_error.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../data_source/authentication_remote_data_source.dart';
import '../models/request_token_model.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationRemoteDataSource _authenticationRemoteDataSource;

  AuthenticationRepositoryImpl(
    this._authenticationRemoteDataSource,
  );

  Future<Either<AppErr, RequestTokenModel>> _getRequestToken() async {
    try {
      final response = await _authenticationRemoteDataSource.getRequestToken();
      return Right(response);
    } on SocketException {
      return Left(AppErr(
          message:
              "No network for getting request token in AuhtenticationRepositoryImpl"));
      ;
    } on Exception {
      return Left(AppErr(
          message:
              "Something went wrong while getting request token in AuhtenticationRepositoryImpl"));
    }
  }

  @override
  Future<Either<AppErr, bool>> loginUser(Map<String, dynamic> body) async {
    var persistantStorage = await SharedPreferences
        .getInstance(); //storing sessionId to sharedPreference

    final requestTokenEitherResponse =
        await _getRequestToken(); //getting new token for logIn
    print("token recieved in loginUser in auth repo");
    final token1 = requestTokenEitherResponse
        .getOrElse(() => RequestTokenModel())
        .requestToken;

    try {
      //setting request token into body
      body.putIfAbsent('request_token', () => token1);
      print("here is req body before sending for login ${body}");
      final validateWithLoginToken = await _authenticationRemoteDataSource
          .validateWithLogin(body); //sending body and recieving validate token
      final sessionId = await _authenticationRemoteDataSource.createSession(
          validateWithLoginToken
              .toJson()); //validating user token and getting sessionId
      if (sessionId != null) {
        print("here is sessionId: ${sessionId}");
        persistantStorage.setString('sessionId', sessionId);
        int? accountId =
            await _authenticationRemoteDataSource.getAccountId(sessionId);

        if (accountId != null) {
          print("account id is :${accountId}");
          persistantStorage.setInt("accountId", accountId);
        } else {
          return Left(AppErr(message: "Could not get accountId"));
        }

        // await _authenticationLocalDataSource.saveSessionId(sessionId);
        return Right(true);
      }
      return Left(AppErr(
          message:
              "Something went wrong while loggin in User in AuhtenticationRepositoryImpl"));
    } on SocketException {
      return Left(AppErr(
          message:
              "No network for  logging in User in AuhtenticationRepositoryImpl"));
    } catch (e) {
      return Left(AppErr(
          message: "Cannot log in. Check username and/or password. \n(${e})"));
    }
  }

  @override
  Future<Either<AppErr, void>> logoutUser() async {
    final pref = await SharedPreferences.getInstance();
    final sessionId = pref.getString("sessionId");
    if (sessionId != null) {
      await Future.wait([
        pref.remove('sessionId'), //deleting from device
        _authenticationRemoteDataSource
            .deleteSession(sessionId) // deleting from server
      ]);
    }
    print(await pref.getString('sessionId'));
    return Right(unit);
  }

  @override
  Future<Either<AppErr, bool>> resumeLogin() async {
    var persistantStorage = await SharedPreferences.getInstance();
    final sessionId = persistantStorage.getString("sessionId");

    //checking if session exist
    if (sessionId != null) {
      return Right(true);
    }
    return left(AppErr(message: "No log in detected. log in required."));
  }
}
