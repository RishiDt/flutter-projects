//Custom Appbar

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_search/movie_search_bloc.dart';
import '../../commons/constants/size_constants.dart';
import '../../commons/screen_utils/screen_util.dart';
import '../journeys/movie_search/custom_search_movie_delegate.dart';
import 'logo.dart';

class MovieAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil.statusBarHeight + Sizes.dimen_4.h,
        left: Sizes.dimen_16.w,
        right: Sizes.dimen_16.w,
      ),

      //using Row

      child: Row(
        children: [
          //For navbar menu button
          IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: SvgPicture.asset(
                'assets/svgs/menu.svg',
                height: Sizes.dimen_12.h,
              )),

          //for Logo
          Expanded(child: Logo(height: Sizes.dimen_14.h)),

          //for search button
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                    BlocProvider.of<MovieSearchBloc>(context),
                  ),
                );
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: Sizes.dimen_12.h,
              )),
        ],
      ),
    );
  }
}
