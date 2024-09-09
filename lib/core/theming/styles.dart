import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle font12WhiteSemiBold = TextStyle(
    fontWeight: FontWeightHelper.semiBold,
    fontSize: 12.sp,
    color: ColorsManager.white,
  );
  static TextStyle font13LightGrayRegular = TextStyle(
    fontWeight: FontWeightHelper.regular,
    fontSize: 13.sp,
    color: ColorsManager.ligtGray,
  );
  static TextStyle font14BlackRegular = TextStyle(
    fontWeight: FontWeightHelper.regular,
    fontSize: 14.sp,
    color: ColorsManager.black,
  );
  static TextStyle font20WhiteMedium = TextStyle(
    fontWeight: FontWeightHelper.medium,
    fontSize: 20.sp,
    color: ColorsManager.white,
  );
  static TextStyle font30WhiteBold = TextStyle(
    fontWeight: FontWeightHelper.bold,
    fontSize: 30.sp,
    color: ColorsManager.white,
  );
}
