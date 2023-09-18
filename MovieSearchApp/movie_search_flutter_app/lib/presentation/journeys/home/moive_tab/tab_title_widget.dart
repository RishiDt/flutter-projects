import 'package:flutter/material.dart';
import 'package:movie_search_flutter_app/commons/extensions/size_extension.dart';

import '../../../../commons/constants/size_constants.dart';
import '../../../themes/app_color.dart';
import '../../../themes/theme_text.dart';

class TabTitleWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isSelected;

  const TabTitleWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? AppColor.royalBlue
                  : Colors.transparent, //changed on tap
              width: Sizes.dimen_1.h,
            ),
          ),
        ),
        child: Text(
          title, //'popular', 'now', 'soon'
          style: isSelected
              ? Theme.of(context).textTheme.royalBlueSubtitle1
              : Theme.of(context).textTheme.subtitle1, //changed on tap
        ),
      ),
    );
  }
}
