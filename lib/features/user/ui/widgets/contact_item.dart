import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/ui/single_chat_screen.dart';
import 'package:chat_app/features/chat/ui/widgets/circle_image.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.user});
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        List<String> members = [
          user.id!,
          FirebaseAuth.instance.currentUser!.uid
        ]..sort((a, b) => a.compareTo(b));
        context.pushNamed(
          Routes.singleChatScreen,
          arguments:
              SingleChatScreen(roomId: members.toString(), chatUser: user),
        );
      },
      leading: CircleImage(image: user.image!),
      title: Text(
        user.name!,
        style: TextStyles.font30WhiteBold.copyWith(fontSize: 14.sp),
      ),
      subtitle: Text(
        user.about!,
        style: TextStyles.font13LightGrayRegular,
      ),
    );
  }
}
