import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:movie_search_flutter_app/data/data_source/authentication_remote_data_source.dart';
import 'package:movie_search_flutter_app/data/data_source/shared_prefernces.dart';
import 'package:movie_search_flutter_app/data/repositories/authentication_repository_impl.dart';
import 'package:movie_search_flutter_app/domain/repositories/authentication_repository.dart';
import 'package:movie_search_flutter_app/domain/usecases/add_movie_to_favorite.dart';
import 'package:movie_search_flutter_app/domain/usecases/check_if_movie_favorite.dart';
import 'package:movie_search_flutter_app/domain/usecases/get_videos.dart';
import 'package:movie_search_flutter_app/domain/usecases/login_user.dart';
import 'package:movie_search_flutter_app/domain/usecases/logout_user.dart';
import 'package:movie_search_flutter_app/domain/usecases/remove_movie_from_favorite.dart';
import 'package:movie_search_flutter_app/domain/usecases/resume_login.dart';
import 'package:movie_search_flutter_app/domain/usecases/search_movie.dart';

import 'package:movie_search_flutter_app/presentation/blocs/cast/cast_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/log_in_out/log_in_out_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_carousal/movie_carousal_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_search/movie_search_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_tab/movie_tab_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_videos/movie_videos_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/usecases/get_cast.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../presentation/blocs/user/user_bloc.dart';
import '/data/core/api_client.dart';
import '/data/data_source/movie_remote_data_source.dart';
import '/data/repositories/movie_repository_impl.dart';
import '/domain/repositories/movie_repository.dart';
import '../domain/usecases/get_coming_soon.dart';
import '../domain/usecases/get_playing_now.dart';
import '../domain/usecases/get_popular.dart';
import '../domain/usecases/get_trending.dart';

final getItInstance = GetIt.I;

Future init() async {
  print("getit.init fired ");
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance
      .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(getItInstance()));

  getItInstance.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<MovieRepository>(
      () => MovieRemoteRepositoryImpl(remoteDataSource: getItInstance()));

  getItInstance.registerLazySingleton<GetTrending>(
      () => GetTrending(moviesRepo: getItInstance()));

  getItInstance.registerLazySingleton<GetPopular>(
      () => GetPopular(moviesRepo: getItInstance()));

  getItInstance.registerLazySingleton<GetPlayingNow>(
      () => GetPlayingNow(moviesRepo: getItInstance()));

  getItInstance.registerLazySingleton<GetComingSoon>(
      () => GetComingSoon(moviesRepo: getItInstance()));

  getItInstance.registerLazySingleton<GetMovieDetail>(
      () => GetMovieDetail(getItInstance()));

  getItInstance
      .registerLazySingleton<SearchMovie>(() => SearchMovie(getItInstance()));

  getItInstance
      .registerLazySingleton<GetVideos>(() => GetVideos(getItInstance()));

  getItInstance.registerLazySingleton<GetCast>(() => GetCast(getItInstance()));
  getItInstance
      .registerLazySingleton<LoginUser>(() => LoginUser(getItInstance()));
  getItInstance.registerLazySingleton(() => LogoutUser(getItInstance()));

  getItInstance
      .registerLazySingleton<ResumeLogin>(() => ResumeLogin(getItInstance()));
  getItInstance.registerLazySingleton<CheckIfFavoriteMovie>(
      () => CheckIfFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<AddMovieToFavorite>(
      () => AddMovieToFavorite(getItInstance()));

  getItInstance.registerLazySingleton<RemoveMovieFromFavorite>(
      () => RemoveMovieFromFavorite(getItInstance()));

  getItInstance.registerLazySingleton<MovieCarousalBloc>(() {
    // if (MovieCarousalBloc(
    //         getTrending: getItInstance<GetTrending>(),
    //         movieBackdropBloc: getItInstance())
    //     .isClosed) {
    //   print("getitInstance has moviecarousal isclosed true");
    //   return new MovieCarousalBloc(
    //       getTrending: getItInstance(), movieBackdropBloc: getItInstance());
    // }
    var bloc = MovieCarousalBloc(
        getTrending: getItInstance<GetTrending>(),
        movieBackdropBloc: getItInstance());
    if (bloc.isClosed) {
      print("moviecarousalbloc  isClosed is true ");
    }
    return bloc;
  });

  // getItInstance.registerLazySingleton<MovieCarousalBloc>(
  //   () =>
  //     MovieCarousalBloc(
  //         getTrending: getItInstance<GetTrending>(),
  //         movieBackdropBloc: getItInstance())

  //         );

  getItInstance
      .registerLazySingleton<MovieBackdropBloc>(() => MovieBackdropBloc());

  getItInstance.registerFactory<MovieDetailBloc>(() => MovieDetailBloc(
      getMovieDetail: getItInstance(),
      castBloc: getItInstance(),
      videosBloc: getItInstance(),
      checkIfFavoriteMovie: getItInstance()));

  getItInstance.registerFactory(() => MovieTabBloc(
      getComingSoon: GetComingSoon(moviesRepo: getItInstance()),
      getPlayingNow: GetPlayingNow(moviesRepo: getItInstance()),
      getPopular: GetPopular(
        moviesRepo: getItInstance(),
      )));

  getItInstance.registerFactory(() => CastBloc(
        getCast: getItInstance(),
      ));

  getItInstance
      .registerFactory(() => MovieVideosBloc(getVideos: getItInstance()));

  getItInstance
      .registerFactory(() => MovieSearchBloc(searchMovie: getItInstance()));

  // getItInstance.registerFactory<SharedPreferences>(
  //     () => PersistantPrefernceStorage().getInstance() as SharedPreferences);

  getItInstance.registerFactory<LogInOutBloc>(() => LogInOutBloc(
      loginUser: getItInstance(),
      logoutUser: getItInstance(),
      resumeLogin: getItInstance()));

  getItInstance.registerFactory<UserBloc>(() => UserBloc(
      addMovieToFavorite: getItInstance(),
      removeMovieFromFavorite: getItInstance()));
}
