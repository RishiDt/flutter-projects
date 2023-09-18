import '../screen_utils/screen_util.dart';

extension ScreenExtension on double {
  double get h => ScreenUtil().setHeight(this);
  double get w => ScreenUtil().setWidth(this);
  double get sp => ScreenUtil().setSp(this);
}
