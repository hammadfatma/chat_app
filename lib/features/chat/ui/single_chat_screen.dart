import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/ui/widgets/circle_image.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleChatScreen extends StatelessWidget {
  const SingleChatScreen(
      {super.key, required this.roomId, required this.chatUser});
  final String roomId;
  final ChatUser chatUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: circleImage(image: chatUser.image!),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatUser.name!,
                style: TextStyles.font30WhiteBold.copyWith(fontSize: 16.sp),
              ),
              Text(chatUser.lastActivated!,
                  style: TextStyles.font12WhiteSemiBold),
            ],
          ),
        ),
      ),
    );
  }
}
