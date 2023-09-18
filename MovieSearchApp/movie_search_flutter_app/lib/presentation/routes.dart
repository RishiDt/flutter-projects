import 'package:flutter/material.dart';
import 'package:movie_search_flutter_app/commons/constants/route_constants.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/presentation/journeys/favorite_screen/favorite_list_builder.dart';

import 'journeys/home_screen.dart';
import 'journeys/login/login_screen.dart';
import 'journeys/movie_detail/movie_detail_arguments.dart';
import 'journeys/movie_detail/movie_detail_screen.dart';
import 'journeys/watch_video/watch_video_arguments.dart';
import 'journeys/watch_video/watch_video_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteConstants.initial: (context) => LoginScreen(),
        RouteConstants.home: (context) => HomeScreen(),
        RouteConstants.movieDetail: (context) => MovieDetailScreen(
              movieDetailArguments: setting.arguments as MovieDetailArguments,
            ),
        RouteConstants.movieVideos: (context) => WatchVideoScreen(
              watchVideoArguments: setting.arguments as WatchVideoArguments,
            ),
        RouteConstants.favoriteScreen: (context) =>
            FavoriteListBuilder(movies: setting.arguments as List<MovieEntity>),
      };
}
