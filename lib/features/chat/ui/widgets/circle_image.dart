import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 55.w,
        height: 55.h,
        child: GestureDetector(
          onTap: () {
            context.pushNamed(Routes.photoViewScreen, arguments: image);
          },
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
      ),
    );
  }
}
