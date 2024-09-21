import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/data/models/room_model.dart';
import 'package:chat_app/features/chat/ui/single_chat_screen.dart';
import 'package:chat_app/features/chat/ui/widgets/circle_image.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.item});
  final ChatRoom item;
  @override
  Widget build(BuildContext context) {
    List member = item.members!
        .where((element) => element != FirebaseAuth.instance.currentUser!.uid)
        .toList();
    String userId =
        member.isEmpty ? FirebaseAuth.instance.currentUser!.uid : member.first;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ChatUser chatUser = ChatUser.fromJson(snapshot.data!.data()!);
          return ListTile(
            onTap: () {
              context.pushNamed(
                Routes.singleChatScreen,
                arguments:
                    SingleChatScreen(roomId: item.id!, chatUser: chatUser),
              );
            },
            leading: circleImage(image: chatUser.image!),
            title: Text(
              chatUser.name ?? chatUser.phone!,
              style: TextStyles.font30WhiteBold.copyWith(fontSize: 14.sp),
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.check,
                  color: ColorsManager.ligtGray,
                ),
                Text(
                  item.lastMessage!,
                  style: TextStyles.font13LightGrayRegular,
                ),
              ],
            ),
            trailing: Column(
              children: [
                Text(
                  item.lastMessageTime!,
                  style: TextStyles.font13LightGrayRegular
                      .copyWith(color: ColorsManager.ligtGreen),
                ),
                ClipOval(
                  child: Container(
                    width: 22.w,
                    height: 22.h,
                    color: ColorsManager.ligtGreen,
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyles.font12WhiteSemiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
