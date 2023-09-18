//obtains data from API for multiple queries

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/data/core/api_client.dart';
import 'package:movie_search_flutter_app/data/data_source/movie_remote_data_source.dart';
import 'package:movie_search_flutter_app/data/models/movie_model.dart';
import 'package:movie_search_flutter_app/domain/entities/app_error.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_detail_entity.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/domain/repositories/movie_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cast_crew_result_data_model.dart';
import '../models/movie_detail_model.dart';
import '../models/video_model.dart';

class MovieRemoteRepositoryImpl extends MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRemoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<AppErr, List<MovieModel>?>> getTrending() async {
    try {
      final movies = await remoteDataSource.getTrending();
      return Right(movies);
    } on Exception {
      return Left(AppErr(
          message:
              "something went wrong while getting trending movies through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, List<MovieEntity>?>> getPolpular() async {
    try {
      final movies = await remoteDataSource.getPopular();
      return Right(movies);
    } on Exception {
      return Left(AppErr(
          message:
              "something went wrong while getting popular movies through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, List<MovieEntity>?>> getPlayingNow() async {
    try {
      final movies = await remoteDataSource.getPlayingNow();
      return Right(movies);
    } on Exception {
      return Left(AppErr(
          message:
              "something went wrong while getting playing now movies through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, List<MovieEntity>?>> getComingSoon() async {
    try {
      final movies = await remoteDataSource.getComingSoon();
      return Right(movies);
    } on Exception {
      return Left(AppErr(
          message:
              "something went wrong while getting coming soon movies through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, MovieDetailModel>> getMovieDetail(int id) async {
    try {
      final movie = await remoteDataSource.getMovieDetail(id);
      return Right(movie);
    } on SocketException {
      return Left(AppErr(
          message:
              "Socket exception occured while getting movie details through remoteDataSource, in movieRepository"));
    } on Exception {
      return Left(AppErr(
          message:
              "something went wrong while getting  movie details movies through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, List<CastModel>>> getCastCrew(int id) async {
    try {
      final castCrew = await remoteDataSource.getCastCrew(id);
      return Right(castCrew);
    } on SocketException {
      return Left(AppErr(
          message:
              "SocketException occured while getting cast through remoteDataSource, in movieRepository"));
    } on Exception {
      return Left(AppErr(
          message:
              "Something went wrong while getting cast through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, List<VideoModel>>> getVideos(int id) async {
    try {
      final videos = await remoteDataSource.getVideos(id);
      return Right(videos);
    } on SocketException {
      return Left(AppErr(
          message:
              "SocketException occured while getting videos through remoteDataSource, in movieRepository"));
    } on Exception {
      return Left(AppErr(
          message:
              "Something went wrong while getting videos through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, List<MovieModel>>> getSearchedMovies(
      String searchTerm) async {
    print("getSearchedMovie() of movie_repo_impl called");
    print("here is searchTerm ${searchTerm}");
    try {
      final movies = await remoteDataSource.getSearchedMovies(searchTerm);
      return Right(movies);
    } on SocketException {
      return Left(AppErr(
          message:
              "SocketException occured while getting search result through remoteDataSource, in movieRepository"));
    } on Exception {
      return Left(AppErr(
          message:
              "Something went wrong while getting search through remoteDataSource, in movieRepository"));
    }
  }

  @override
  Future<Either<AppErr, List<String?>>> getFavorites() async {
    final persistantStorage = await SharedPreferences.getInstance();
    late List<String>? movieIds = persistantStorage.getStringList("favs");
    //temporarily forcing server fetch
    //this keeps movie detial screen more consistant
    movieIds = null;
    final sessionId = persistantStorage.getString("sessionId");
    final accountId = persistantStorage.getInt("accountId");

    //get from server if not present locally
    if (movieIds == null && (sessionId != null && accountId != null)) {
      final movies = await remoteDataSource.getFavorites(accountId, sessionId);
      print("here are the obtained for getFavorite \n${movies}");

      movieIds = [];
      movies.forEach((movie) {
        //getting movie ids into a string list
        movieIds!.add(movie.id.toString());
      });

      //storing into persistance storage
      persistantStorage.setStringList("favs", movieIds);
    }

    return movieIds != null
        ? Right(movieIds)
        : Left(AppErr(message: "no favorite movies found."));
  }

  @override
  Future<Either<AppErr, bool>> removeMovieFromFavorite(int movieId) async {
    final persistantStorage = await SharedPreferences.getInstance();
    final accountId = persistantStorage.getInt("accountId");
    final sessionId = persistantStorage.getString("sessionId");

    if (accountId != null && sessionId != null) {
      try {
        await remoteDataSource.removeMovieFromFavorite(
            accountId, sessionId, movieId);

        //resets favs List stored on device. this will cause next subsequent calls to
        //getFavorite to get favorite movies from server.
        await persistantStorage.remove("favs");
      } catch (e) {
        print("error captured in movie repo impl");
        return Left(AppErr(message: e.toString()));
      }
      //right type is void but if no args specified then Right gives error for posnal args
      return Right(false);
    }
    return Left(AppErr(message: "accountId is null"));
  }

  @override
  Future<Either<AppErr, bool>> addMovieToFavorite(int movieId) async {
    //pass  movie id to addtofavorite(id) datasource method and get a response
    //depending upon status of (bool)response create a Right or Left
    final persistantStorage = await SharedPreferences.getInstance();
    final accountId = persistantStorage.getInt("accountId");
    final sessionId = persistantStorage.getString("sessionId");

    if (accountId != null && sessionId != null) {
      try {
        await remoteDataSource.addMovieToFavorite(
            accountId, sessionId, movieId);

        //resets favs List stored on device. this will cause next subsequent calls to
        //getFavorite to get favorite movies from server.
        await persistantStorage.remove("favs");
      } catch (e) {
        print("error captured in movie repo impl");
        return Left(AppErr(message: e.toString()));
      }
      //right type is void but if no args specified then Right gives error for posnal args
      return Right(false);
    }
    return Left(AppErr(message: "accountId is null"));
  }
}
