import 'package:flutter/material.dart';

import '../../../domain/entities/movie_entity.dart';
import '../movie_search/search_movie_card.dart';

class FavoriteListBuilder extends StatelessWidget {
  final List<MovieEntity> movies;

  const FavoriteListBuilder({required this.movies});

  @override
  Widget build(BuildContext context) {
    ListView view = ListView.builder(
      itemBuilder: (context, index) => SearchMovieCard(
        movie: movies[index],
      ),
      itemCount: movies.length,
      scrollDirection: Axis.vertical,
    );

    return view;
  }
}
