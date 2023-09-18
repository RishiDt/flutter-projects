//working module for data layer repository

import 'dart:convert';
import 'package:http/http.dart';
import 'package:movie_search_flutter_app/data/core/api_client.dart';
import 'package:movie_search_flutter_app/data/core/api_constants.dart';
import 'package:movie_search_flutter_app/data/models/movie_model.dart';
import 'package:movie_search_flutter_app/data/models/movie_result_model.dart';

import '../models/cast_crew_result_data_model.dart';
import '../models/movie_detail_model.dart';
import '../models/video_model.dart';
import '../models/video_result_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>?> getTrending();
  Future<List<MovieModel>?> getPopular();
  Future<List<MovieModel>?> getPlayingNow();
  Future<List<MovieModel>?> getComingSoon();
  Future<MovieDetailModel> getMovieDetail(int id);
  Future<List<CastModel>> getCastCrew(int id);
  Future<List<VideoModel>> getVideos(int id);
  Future<List<MovieModel>> getSearchedMovies(String searchTerm);
  Future<List<MovieModel>> getFavorites(int accountId, String sessionId);
  Future<void> addMovieToFavorite(int accountId, String sessionId, int movieId);
  Future<void> removeMovieFromFavorite(
      int accountId, String sessionId, int movieId);
}

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<MovieModel>?> getTrending() async {
    final jsonResponse = await apiClient.get('/trending/movie/day');

    //gets the result object mapped to  movies list
    final movies = MovieResultModel.fromJson(jsonResponse).movies;

    //print(movies); //props MovieModel(id, name)
    return movies;
  }

  @override
  Future<List<MovieModel>?> getPopular() async {
    final jsonResponse = await apiClient.get('/movie/popular');

    //gets the result json mapped to  movies list
    final movies = MovieResultModel.fromJson(jsonResponse).movies;

    //print(movies); //props MovieModel(id, name)
    return movies;
  }

  @override
  Future<List<MovieModel>?> getPlayingNow() async {
    final jsonResponse = await apiClient.get('/movie/now_playing');

    //gets the result json mapped to  movies list
    final movies = MovieResultModel.fromJson(jsonResponse).movies;

    //print(movies); //props MovieModel(id, name)
    return movies;
  }

  @override
  Future<List<MovieModel>?> getComingSoon() async {
    final jsonResponse = await apiClient.get('/movie/upcoming');

    //gets the result json mapped to  movies list
    final movies = MovieResultModel.fromJson(jsonResponse).movies;

    //print(movies); //props MovieModel(id, name)
    return movies;
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) async {
    final response = await apiClient.get('/movie/$id');
    final movie = MovieDetailModel.fromJson(response);
    print(movie);
    return movie;
  }

  @override
  Future<List<CastModel>> getCastCrew(int id) async {
    final response = await apiClient.get('/movie/$id/credits');
    final cast = CastCrewResultModel.fromJson(response).cast;
    return cast;
  }

  @override
  Future<List<VideoModel>> getVideos(int id) async {
    final response = await apiClient.get('/movie/$id/videos');
    final videos = VideoResultModel.fromJson(response).videos;
    return videos;
  }

  @override
  Future<List<MovieModel>> getSearchedMovies(String searchTerm) async {
    print("getsearchedMovies() of remotedatasource called");
    final response = await apiClient.get('/search/movie', params: {
      'query': searchTerm,
    });
    print(response);
    final movies = MovieResultModel.fromJson(response).movies;
    print("search result");
    print(movies);
    return movies;
  }

  @override
  Future<List<MovieModel>> getFavorites(int accountId, String sessionId) async {
    final response = await apiClient.get(
        "/account/${accountId}/favorite/movies",
        params: {"session_id": sessionId});

    print(response);
    final movies = MovieResultModel.fromJson(response).movies;
    print("Favorite movies");
    print(movies);
    return movies;
  }

  @override
  Future<void> removeMovieFromFavorite(
      int accountId, String sessionId, int movieId) async {
    final bodyParams = {
      "media_type": "movie",
      "media_id": movieId,
      "favorite": false
    };
    final pathParams = {
      "session_id": sessionId,
    };
    try {
      final response = await apiClient.post("/account/${accountId}/favorite",
          params: bodyParams, pathParams: pathParams);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> addMovieToFavorite(
      int accountId, String sessionId, int movieId) async {
    final bodyParams = {
      "media_type": "movie",
      "media_id": movieId,
      "favorite": true
    };
    final pathParams = {
      "session_id": sessionId,
    };
    try {
      final response = await apiClient.post("/account/${accountId}/favorite",
          params: bodyParams, pathParams: pathParams);
    } catch (e) {
      throw e;
    }
  }
}
