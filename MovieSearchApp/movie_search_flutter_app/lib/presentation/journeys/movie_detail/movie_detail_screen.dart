import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';
import 'package:movie_search_flutter_app/domain/entities/movie_detail_entity.dart';
import 'package:movie_search_flutter_app/presentation/blocs/cast/cast_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_videos/movie_videos_bloc.dart';
import 'package:movie_search_flutter_app/presentation/journeys/movie_detail/TrailerButton.dart';
import '../../../commons/constants/size_constants.dart';
import 'big_poster.dart';
import 'cast_widget.dart';
import 'movie_detail_arguments.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieDetailArguments movieDetailArguments;

  const MovieDetailScreen({
    Key? key,
    required this.movieDetailArguments,
  }) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final MovieDetailBloc _movieDetailBloc;
  late final MovieDetailEntity movieDetailEntity;
  late final CastBloc _castBloc;
  late final MovieVideosBloc _movieVideosBloc;
  @override
  void initState() {
    super.initState();
    _movieDetailBloc = getItInstance<MovieDetailBloc>();
    _castBloc = _movieDetailBloc.castBloc;
    _movieVideosBloc = _movieDetailBloc.videosBloc;
    _movieDetailBloc.add(
        MovieDetailLoadEvent(movieId: widget.movieDetailArguments.movieId));
  }

  @override
  void dispose() {
    _movieVideosBloc.close();
    _castBloc.close();
    _movieDetailBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('_moviedetailbloc is ${_movieDetailBloc}');
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _movieDetailBloc),
          BlocProvider.value(value: _castBloc),
          BlocProvider.value(value: _movieVideosBloc)
        ],
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
            builder: (context, state) {
          if (state is MovieDetailLoadedState) {
            movieDetailEntity = state.movie;
            return SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BigPoster(movie: state.movie),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.dimen_16.w,
                    vertical: Sizes.dimen_8.h,
                  ),
                  child: Text(
                    movieDetailEntity.overview ?? '',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w),
                  child: Text(
                    "cast",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                CastWidget(),
                TrailerButton(videosBLoc: _movieVideosBloc),
              ],
            ));
          } else if (state is MovieDetailErrorState) {
            return Container(
              color: Colors.white,
            );
          }

          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
