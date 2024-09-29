import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget showDate(String date) {
  return Container(
    width: 109.w,
    height: 33.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: ColorsManager.darkGray),
    child: Center(
      child: Text(
        date,
        style:
            TextStyles.font13LightGrayRegular.copyWith(color: ColorsManager.gray),
      ),
    ),
  );
}
