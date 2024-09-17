import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

Widget buildProfileImage(context, bcontext) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      ClipOval(
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/chat-app-95f3c.appspot.com/o/profile%2Fprofile_image.png?alt=media&token=98017798-3968-43b5-9124-0eb5b3e747bc',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.ligtGreen,
              ),
            );
          },
          width: 132.w,
          height: 132.h,
        ),
      ),
      Positioned(
        bottom: 9,
        right: 9,
        child: ClipOval(
          child: Container(
            color: ColorsManager.ligtGreen,
            width: 32.w,
            height: 32.h,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('choose what you want'),
                    actions: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('Camera'),
                        onTap: () {
                          Navigator.pop(context);
                          BlocProvider.of<ProfileCubit>(bcontext)
                              .getProfileImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: const Text('Gallery'),
                        onTap: () {
                          Navigator.pop(context);
                          BlocProvider.of<ProfileCubit>(bcontext)
                              .getProfileImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.camera_alt,
                size: 12,
                color: ColorsManager.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
