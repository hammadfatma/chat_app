import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget noItemFound({required String typeName}) {
  return Center(
    child: Text(
      'You haven\'t $typeName',
      style: TextStyles.font20WhiteMedium.copyWith(fontSize: 32.sp),
    ),
  );
}
