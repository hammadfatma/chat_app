import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildNextButton(
  BuildContext context, {
  void Function()? onPressed,
  required String text,
}) {
  return Align(
    alignment: Alignment.center,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(60.w, 50.h),
        backgroundColor: ColorsManager.ligtGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      child: Text(
        text,
        style: TextStyles.font12WhiteSemiBold,
      ),
    ),
  );
}
