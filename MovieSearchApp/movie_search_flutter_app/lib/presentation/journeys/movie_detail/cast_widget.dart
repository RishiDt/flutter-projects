import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';

import '../../../commons/constants/size_constants.dart';
import '../../../data/core/api_constants.dart';
import '../../blocs/cast/cast_bloc.dart';
import '../../themes/theme_text.dart';

class CastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CastBloc, CastState>(
      builder: (context, state) {
        print("castblocstate is ${state}");
        if (state is CastLoadedState) {
          return Container(
            //listview container for scrollable list
            height: Sizes.dimen_100.h,
            child: ListView.builder(
              //listview
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.casts.length, //getting total items
              itemBuilder: (context, index) {
                final castEntity = state.casts[index];
                return Container(
                  //card container
                  height: Sizes.dimen_100.h,
                  width: Sizes.dimen_160.w,
                  child: Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(
                      horizontal: Sizes.dimen_8.w,
                      vertical: Sizes.dimen_4.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.dimen_8.w),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Sizes.dimen_8.w),
                            ),
                            child: CachedNetworkImage(
                              height: Sizes.dimen_100.h,
                              width: Sizes.dimen_160.w,
                              imageUrl:
                                  '${ApiConstants.BASE_IMAGE_URL}${castEntity.posterPath}',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.dimen_8.w,
                          ),
                          child: Text(castEntity.name,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.vulcanBodyText2
                              // : Theme.of(context).textTheme.whiteBodyText2,
                              ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Sizes.dimen_8.w,
                            right: Sizes.dimen_8.w,
                            bottom: Sizes.dimen_2.h,
                          ),
                          child: Text(
                            castEntity.character,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
