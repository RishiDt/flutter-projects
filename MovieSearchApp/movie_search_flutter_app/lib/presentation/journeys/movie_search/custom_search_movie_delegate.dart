import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_search_params.dart';
import 'package:movie_search_flutter_app/domain/usecases/search_movie.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_search/movie_search_bloc.dart';

import '../../../commons/constants/size_constants.dart';
import '../../themes/app_color.dart';
import 'search_movie_card.dart';

class CustomSearchDelegate extends SearchDelegate {
  late final MovieSearchBloc movieSearchBloc;

  CustomSearchDelegate(this.movieSearchBloc);

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: query.isEmpty ? Colors.grey : Colors.white,
        ),
        onPressed: query.isEmpty ? null : () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: AppColor.vulcan,
        size: Sizes.dimen_12.h,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print("BuildResult() of searchdelegate fired");
    movieSearchBloc.add(ResetEvent());
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      bloc: movieSearchBloc,
      builder: (context, state) {
        movieSearchBloc.add(SearchMovieEvent(
            searchQuery:
                query)); //this forces new state in builder callback getting rid of previous state movies
        if (state is MovieSearchErrorState) {
          // return AppErrorWidget(
          //   errorType: state.errorType,
          //   onPressed: () => searchMovieCubit.searchTermChanged(query),
          // );
        } else if (state is MovieSearchLoadedState) {
          final movies = state.movies;
          if (movies.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_64.w),
                child: const Text(
                  "No movies found",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          print("movies in resultBuilder are: ${state.movies}");
          ListView view = ListView.builder(
            itemBuilder: (context, index) => SearchMovieCard(
              movie: movies[index],
            ),
            itemCount: movies.length,
            scrollDirection: Axis.vertical,
          );

          return view;
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox.shrink();
  }
}
