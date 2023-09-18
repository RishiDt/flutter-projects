import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/di/get_it.dart';

import 'package:movie_search_flutter_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_carousal/movie_carousal_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_search/movie_search_bloc.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_tab/movie_tab_bloc.dart';

import '../blocs/user/user_bloc.dart';
import 'drawer/navigation_drawer.dart';
import 'home/moive_carousal/movie_carousel_widget.dart';
import 'home/moive_tab/tab_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieCarousalBloc movieCarousalBloc;
  late MovieBackdropBloc movieBackdropBloc;
  late MovieTabBloc movieTabBloc;
  late MovieSearchBloc movieSearchBloc;
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();

    movieCarousalBloc = getItInstance<MovieCarousalBloc>();

    movieBackdropBloc = movieCarousalBloc.movieBackdropBloc;
    movieTabBloc = getItInstance<MovieTabBloc>();
    movieSearchBloc = getItInstance<MovieSearchBloc>();
    movieCarousalBloc.add(CarousalLoadEvent());
  }

  @override
  void dispose() {
    super.dispose();
    movieSearchBloc.close();
    movieCarousalBloc.close();
    movieBackdropBloc.close();
    movieTabBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => movieCarousalBloc,
        ),
        BlocProvider(
          create: (context) => movieBackdropBloc,
        ),
        BlocProvider(
          create: (context) => movieTabBloc,
        ),
        BlocProvider(
          create: (context) => movieSearchBloc,
        ),
      ],
      child: Scaffold(
          drawer: CustomNavigationDrawer(),
          body: BlocBuilder<MovieCarousalBloc, MovieCarousalState>(
            builder: (context, state) {
              if (state is MovieCarousalLoaded) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.6,
                      //movie carousal widget
                      child: MovieCarouselWidget(
                        movies: state.movies,
                        defaultIndex: state.defaultIndex,
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 0.4,
                      child: MovieTabbedWidget(),
                    ),
                  ],
                );
              }

              return Container();
            },
          )),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
