import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/check_if_movie_favorite.dart';

import 'package:movie_search_flutter_app/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import '../../../commons/constants/route_constants.dart';
import '../../../commons/constants/size_constants.dart';
import '../../../domain/entities/movie_detail_entity.dart';
import '../../blocs/user/user_bloc.dart';
import '../../themes/app_color.dart';
import 'movie_detail_arguments.dart';

class MovieDetailAppBar extends StatelessWidget {
  //this file has not been used
  final MovieDetailEntity movieDetailEntity;

  //to fire add and remove favorite event.
  final UserBloc userBloc = getItInstance();
  MovieDetailAppBar({
    Key? key,
    required this.movieDetailEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: Sizes.dimen_12.h,
          ),
        ),
        BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoadedState) {
              final isfavDirect = getItInstance<CheckIfFavoriteMovie>()(
                  MovieParams(state.movie.id));
              print(
                  "state is moviedetailloaded in movie detail appbar \n and isfav is ${state.isFav}");
              return GestureDetector(
                onTap: () {
                  //parent widget should supply blocs
                  state.isFav
                      ? userBloc.add(
                          RemoveMovieFromFavoriteEvent(movieId: state.movie.id))
                      : userBloc.add(
                          AddMovieToFavoriteEvent(movieId: state.movie.id));

                  Navigator.of(context).popAndPushNamed(
                      RouteConstants.movieDetail,
                      arguments: MovieDetailArguments(state.movie.id));
                },
                child: Icon(
                  state.isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: Sizes.dimen_12.h,
                ),
              );
            } else {
              print("state is not loaded : ${state}");
              return Icon(
                Icons.crisis_alert,
                color: Colors.white,
                size: Sizes.dimen_12.h,
              );
            }
          },
        ),

        // IconButton(
        //   onPressed: ,
        //   icon:  Icon(
        //   Icons.favorite,
        //   color: Colors.white,
        //   size: Sizes.dimen_12.h,
        // )
        //   )
      ],
    );
  }
}
