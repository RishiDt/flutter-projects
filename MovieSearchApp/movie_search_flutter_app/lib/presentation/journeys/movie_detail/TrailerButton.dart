import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/constants/route_constants.dart';
import 'package:movie_search_flutter_app/presentation/blocs/movie_videos/movie_videos_bloc.dart';
import 'package:movie_search_flutter_app/presentation/journeys/watch_video/watch_video_arguments.dart';
import 'package:movie_search_flutter_app/presentation/journeys/watch_video/watch_video_screen.dart';

import '../../widgets/button.dart';

class TrailerButton extends StatelessWidget {
  final MovieVideosBloc videosBLoc;

  const TrailerButton({
    Key? key,
    required this.videosBLoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieVideosBloc, MovieVideosState>(
      builder: (context, state) {
        if (state is MovieVideosLoadedState &&
            state.videos.iterator.moveNext()) {
          final _videos = state.videos;
          return Button(
            text: "Watch Trailers",
            onPressed: () {
              Navigator.of(context).pushNamed(RouteConstants.movieVideos,
                  arguments: WatchVideoArguments(_videos));
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => WatchVideoScreen(
              //           watchVideoArguments: WatchVideoArguments(_videos))),
              // );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
