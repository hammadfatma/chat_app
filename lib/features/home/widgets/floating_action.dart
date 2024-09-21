import 'package:chat_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

Widget buildfloatingActionButton({
  required void Function()? onPressed,
  required IconData icon,
}) {
  return FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: ColorsManager.ligtGreen,
    foregroundColor: ColorsManager.white,
    child: Icon(
      icon,
      size: 20,
    ),
  );
}
