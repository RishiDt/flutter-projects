import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/presentation/journeys/home/moive_tab/tab_constants.dart';
import 'package:movie_search_flutter_app/presentation/journeys/home/moive_tab/tab_title_widget.dart';

import '../../../../commons/constants/size_constants.dart';
import '../../../blocs/movie_tab/movie_tab_bloc.dart';
import 'list_view_builder.dart';

class MovieTabbedWidget extends StatefulWidget {
  @override
  _MovieTabbedWidgetState createState() => _MovieTabbedWidgetState();
}

class _MovieTabbedWidgetState extends State<MovieTabbedWidget>
    with SingleTickerProviderStateMixin {
  MovieTabBloc get movieTabBloc => BlocProvider.of<MovieTabBloc>(context);

//  MovieTabBloc get MovieTabBloc => BlocProvider.of<MovieTabBloc>(context);

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    movieTabBloc.add(MovieTabChangedEvent(currentTabIndex: currentTabIndex));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieTabBloc, MovieTabState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: Sizes.dimen_4.h),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < TabConstants.movieTabs.length; i++)
                    TabTitleWidget(
                      title: TabConstants.movieTabs[i].title,
                      onTap: () => _onTabTapped(i),
                      isSelected: TabConstants.movieTabs[i].index ==
                          state.currentTabIndex,
                    )
                ],
              ),
              if (state is MovieTabChangedState)
                Expanded(
                    child: ListViewBuilder(
                  movies: state.movies!,
                ))
            ],
          ),
        );
      },
    );
  }

  void _onTabTapped(int index) {
    movieTabBloc.add(MovieTabChangedEvent(currentTabIndex: index));
  }
}
