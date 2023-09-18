//abstraction over the data layer. implemented at movie_repository_impl in /data/repositories

import 'package:dartz/dartz.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/domain/entities/app_error.dart';

import '../entities/cast_entity.dart';
import '../entities/movie_detail_entity.dart';
import '../entities/video_entity.dart';

abstract class MovieRepository {
  Future<Either<AppErr, List<MovieEntity>?>> getTrending();
  Future<Either<AppErr, List<MovieEntity>?>> getPolpular();
  Future<Either<AppErr, List<MovieEntity>?>> getPlayingNow();
  Future<Either<AppErr, List<MovieEntity>?>> getComingSoon();
  Future<Either<AppErr, MovieDetailEntity>> getMovieDetail(int id);
  Future<Either<AppErr, List<CastEntity>>> getCastCrew(int id);
  Future<Either<AppErr, List<VideoEntity>>> getVideos(int id);
  Future<Either<AppErr, List<MovieEntity>>> getSearchedMovies(
      String searchTerm);
  Future<Either<AppErr, List<String?>>> getFavorites();
  Future<Either<AppErr, bool>> addMovieToFavorite(int id);
  Future<Either<AppErr, bool>> removeMovieFromFavorite(int movieId);
}
