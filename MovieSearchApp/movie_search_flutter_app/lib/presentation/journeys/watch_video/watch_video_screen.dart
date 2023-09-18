import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../commons/constants/size_constants.dart';
import '../../../domain/entities/video_entity.dart';
import 'watch_video_arguments.dart';

class WatchVideoScreen extends StatefulWidget {
  final WatchVideoArguments watchVideoArguments;

  const WatchVideoScreen({
    Key? key,
    required this.watchVideoArguments,
  }) : super(key: key);

  @override
  _WatchVideoScreenState createState() => _WatchVideoScreenState();
}

class _WatchVideoScreenState extends State<WatchVideoScreen> {
  late List<VideoEntity> _videos;
  late YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _videos = widget.watchVideoArguments.videos;
    _controller = YoutubePlayerController(
      initialVideoId: _videos[0].key,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Watch Trailers",
        ),
      ),
      body: YoutubePlayerBuilder(
        //YoutubePlayerBuilder
        player: YoutubePlayer(
          //YoutubePlayer
          controller: _controller ?? //YoutubePlayerController
              YoutubePlayerController(
                initialVideoId: _videos[0].key,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  mute: true,
                ),
              ),
          aspectRatio: 16 / 9,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
        builder: (context, player) {
          return Column(
            children: [
              player,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Column that shows list of youtube video thumbnail
                      for (int i = 0; i < _videos.length; i++)
                        Container(
                          height: Sizes.dimen_60.h,
                          padding:
                              EdgeInsets.symmetric(vertical: Sizes.dimen_8.h),
                          child: Row(
                            //using row to make each youtube video tile
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _controller?.load(_videos[i].key);
                                  _controller?.play();
                                },
                                child: CachedNetworkImage(
                                  //getting thumbnail
                                  width: Sizes.dimen_200.w,
                                  imageUrl: YoutubePlayer.getThumbnail(
                                    videoId: _videos[i].key,
                                    quality: ThumbnailQuality.high,
                                  ),
                                ),
                              ),
                              Expanded(
                                //video title tile
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_8.w),
                                  child: Text(
                                    _videos[i].title,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
