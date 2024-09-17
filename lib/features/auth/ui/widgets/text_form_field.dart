import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget showTextFormField({
  String? Function(String?)? validator,
  void Function(String?)? onSaved,
  TextInputType? keyboardType,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: ColorsManager.ligtGreen),
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide.none,
      ),
    ),
    child: TextFormField(
      scrollPadding: EdgeInsets.zero,
      style: TextStyles.font14BlackRegular.copyWith(
        letterSpacing: 2.0,
        color: ColorsManager.white,
      ),
      decoration: const InputDecoration(border: InputBorder.none),
      cursorColor: ColorsManager.ligtGreen,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    ),
  );
}
