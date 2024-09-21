import 'package:chat_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget circleImage({required String image}) {
  return ClipOval(
    child: SizedBox(
      width: 55.w,
      height: 55.h,
      child: Image.network(
        image,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              color: ColorsManager.ligtGreen,
            ),
          );
        },
      ),
    ),
  );
}
