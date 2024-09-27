import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, this.onChanged, this.controller, this.hintText});
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: TextField(
        onSubmitted: (value) => value.isEmpty ? "Requird" : null,
        onChanged: onChanged,
        style: TextStyles.font12WhiteSemiBold,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorsManager.ligtGreen),
          ),
          hintText: hintText,
          hintStyle: TextStyles.font13LightGrayRegular,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
