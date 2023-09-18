//widget responsible for carousal
//movie_carousal_widget<-movie_page_view<-movie_card_widget
import 'package:flutter/material.dart';

import 'package:movie_search_flutter_app/presentation/widgets/separator.dart';

import '../../../../domain/entities/movie_entity.dart';
import '../../../widgets/movie_app_bar.dart';
import 'movie_backdrop_widget.dart';
import 'movie_data_widget.dart';
import 'movie_page_view.dart';

class MovieCarouselWidget extends StatelessWidget {
  final List<MovieEntity>? movies;
  final int defaultIndex;

  const MovieCarouselWidget({
    Key? key,
    required this.movies,
    this.defaultIndex = 0,
  })  : assert(defaultIndex >= 0, 'defaultIndex cannot be less than 0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MovieBackdropWidget(),
        Column(
          children: [
            MovieAppBar(), //top appbar
            MoviePageView(
              movies: movies,
              initialPage: defaultIndex,
            ), //cards
            MovieDataWidget(), //title
            Separator(), //line
          ],
        ),
      ],
    );
  }
}
