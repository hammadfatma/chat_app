import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

Widget buildIntroTexts({
  required String firstText,
  required String secondText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        firstText,
        style: TextStyles.font20WhiteMedium,
      ),
      verticalSpace(30),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          secondText,
          style: TextStyles.font13LightGrayRegular
              .copyWith(color: ColorsManager.white),
        ),
      ),
    ],
  );
}
