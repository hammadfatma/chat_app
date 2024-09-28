import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

Widget profileListTile({
  String? isPhone,
  void Function()? trailingEdit,
  required IconData leadingIcon,
  required String titleText,
  required String subtitleText,
}) {
  return ListTile(
    leading: Icon(
      leadingIcon,
      size: 22,
      color: ColorsManager.gray,
    ),
    title: Text(
      titleText,
      style:
          TextStyles.font13LightGrayRegular.copyWith(color: ColorsManager.gray),
    ),
    subtitle: Text(
      subtitleText,
      style: TextStyles.font13LightGrayRegular
          .copyWith(color: ColorsManager.white),
    ),
    trailing: isPhone == 'yes'
        ? const SizedBox()
        : IconButton(
            onPressed: trailingEdit,
            icon: const Icon(
              Icons.edit,
              color: ColorsManager.ligtGreen,
              size: 11,
            ),
          ),
  );
}
