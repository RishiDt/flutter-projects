import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/constants/route_constants.dart';
import 'package:movie_search_flutter_app/commons/screen_utils/screen_util.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:movie_search_flutter_app/presentation/blocs/log_in_out/log_in_out_bloc.dart';
import 'package:movie_search_flutter_app/presentation/themes/app_color.dart';
import 'package:movie_search_flutter_app/presentation/themes/theme_text.dart';

import '../fade_page_route_builder.dart';
import '../journeys/home_screen.dart';
import '../routes.dart';

class MovieApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MovieAppState();
  }
}

class _MovieAppState extends State<MovieApp> {
  // late LogInOutBloc logInOutBloc;
  @override
  void initState() {
    // logInOutBloc = getItInstance<LogInOutBloc>();
    super.initState();
  }

  @override
  void dispose() {
    // logInOutBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primaryColor: AppColor.vulcan,
        scaffoldBackgroundColor: AppColor.vulcan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeText.getTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      builder: (context, child) {
        return child!;
      },
      initialRoute: RouteConstants.initial, //toLogin screen
      onGenerateRoute: (RouteSettings settings) {
        final routes = Routes.getRoutes(settings);
        final WidgetBuilder? builder = routes[settings.name];
        return FadePageRouteBuilder(
          builder: builder!,
          settings: settings,
        );
      },
    );
  }
}
// BlocBuilder<LogInOutBloc, LogInOutState>(
//         bloc: logInOutBloc,
//         builder: (context, state) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Movie App',
//             theme: ThemeData(
//               primaryColor: AppColor.vulcan,
//               scaffoldBackgroundColor: AppColor.vulcan,
//               visualDensity: VisualDensity.adaptivePlatformDensity,
//               textTheme: ThemeText.getTextTheme(),
//               appBarTheme: const AppBarTheme(elevation: 0),
//             ),
//             builder: (context, child) {
//               return child!;
//             },
//             initialRoute: RouteConstants.initial, //toLogin screen
//             onGenerateRoute: (RouteSettings settings) {
//               final routes = Routes.getRoutes(settings);
//               final WidgetBuilder? builder = routes[settings.name];
//               return FadePageRouteBuilder(
//                 builder: builder!,
//                 settings: settings,
//               );
//             },
//           );
//         });