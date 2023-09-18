////movie_carousal_widget<-movie_page_view<-movie_card_widget
//widget listed in carousal

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search_flutter_app/commons/constants/route_constants.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:movie_search_flutter_app/presentation/journeys/movie_detail/movie_detail_screen.dart';
import '../../../../commons/constants/size_constants.dart';
import '../../../../data/core/api_constants.dart';

class MovieCardWidget extends StatelessWidget {
  final int movieId;
  final String posterPath;

  const MovieCardWidget({
    Key? key,
    required this.movieId,
    required this.posterPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 32,
      borderRadius: BorderRadius.circular(Sizes.dimen_16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(RouteConstants.movieDetail,
              arguments: MovieDetailArguments(movieId));
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => MovieDetailScreen(
          //       movieDetailArguments: MovieDetailArguments(movieId)),
          // ));
        },

        //for rectangle clipping with rounded corners
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.dimen_16.w),

          //network image widget
          child: CachedNetworkImage(
            imageUrl: '${ApiConstants.BASE_IMAGE_URL}$posterPath',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
