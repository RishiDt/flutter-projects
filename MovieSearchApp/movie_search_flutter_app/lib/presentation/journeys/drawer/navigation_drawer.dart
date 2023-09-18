import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/constants/route_constants.dart';
import 'package:movie_search_flutter_app/commons/constants/size_constants.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/data/data_source/movie_remote_data_source.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_entity.dart';
import 'package:movie_search_flutter_app/presentation/blocs/log_in_out/log_in_out_bloc.dart';
import 'package:movie_search_flutter_app/presentation/journeys/drawer/navigation_list_item.dart';
import 'package:movie_search_flutter_app/presentation/journeys/favorite_screen/favorite_list_builder.dart';
import 'package:movie_search_flutter_app/presentation/journeys/feedback/email_composer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/logo.dart';
import '../about/about_screen.dart';

class CustomNavigationDrawer extends StatelessWidget {
  late final LogInOutBloc logInOutBloc = getItInstance<LogInOutBloc>();

  //trying to use data layer module in presentation layer directly !
  late final MovieRemoteDataSource movieRemoteDataSource = getItInstance();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            blurRadius: 4,
          ),
        ],
      ),
      width: Sizes.dimen_300.w,
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: Sizes.dimen_8.h,
              bottom: Sizes.dimen_18.h,
              left: Sizes.dimen_8.w,
              right: Sizes.dimen_8.w,
            ),
            child: Logo(
              height: Sizes.dimen_48.h,
            ),
          ),
          NavigationListItem(
              title: 'Favorite Movies',
              onPressed: () async {
                //testing purpose code only
                var aid = await SharedPreferences.getInstance()
                    .then((value) => value.getInt("accountId"));
                var sid = await SharedPreferences.getInstance()
                    .then((value) => value.getString("sessionId"));
                List<MovieEntity> movies = await movieRemoteDataSource
                    .getFavorites(aid!, sid!)
                    .then((value) => value);

                Navigator.of(context).pushNamed(RouteConstants.favoriteScreen,
                    arguments: movies);
                // FavoriteListBuilder(
                //   movies: movies,
                // );
              }),
          NavigationListItem(
              title: 'Feedback',
              onPressed: () {
                Navigator.push(
                    context,
                    //use app's routing instead of direct push
                    MaterialPageRoute(
                        builder: (context) => EmailComposeScreen()));
              }),
          NavigationListItem(
              title: 'About',
              onPressed: () {
                //use app's routing instead of direct push
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutScreen()));
              }),
          BlocConsumer<LogInOutBloc, LogInOutState>(
            bloc: logInOutBloc,
            buildWhen: (previous, current) => current is LogInSuccessState,
            builder: (context, state) {
              return NavigationListItem(
                  title: "Log Out",
                  onPressed: () {
                    print("logout pressed");

                    logInOutBloc.add(LogOutEvent());
                  });
            },
            listenWhen: (previous, current) {
              return current is LogOutSuccesState;
            },
            listener: (context, state) {
              print("state in listener is ${state}");
              //resets all registered instances so that
              //new bloc instances are provided instead of close ones.
              getItInstance.reset();
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteConstants.initial,
                (route) => false,
              );
            },
          ),
        ],
      )),
    );
  }
}
