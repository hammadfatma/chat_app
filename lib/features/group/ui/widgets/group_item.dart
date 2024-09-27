import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/ui/widgets/circle_image.dart';
import 'package:chat_app/features/group/data/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({super.key, required this.item});
  final ChatGroup item;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.pushNamed(
          Routes.singleGroupScreen,
          arguments: item,
        );
      },
      leading: circleImage(image: item.image!),
      title: Text(
        item.name!,
        style: TextStyles.font30WhiteBold.copyWith(fontSize: 14.sp),
      ),
      subtitle: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('groups')
              .doc(item.id)
              .collection('messages')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Message> messages = snapshot.data!.docs
                  .map((element) => Message.fromJson(element.data()))
                  .toList()
                ..sort(
                  (a, b) => b.createdAt!.compareTo(a.createdAt!),
                );
              if (messages.first.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return Row(
                  children: [
                    Icon(
                      Icons.done_all,
                      color: messages.first.read == ''
                          ? ColorsManager.ligtGray
                          : ColorsManager.blue,
                    ),
                    Text(
                      item.lastMessage == ""
                          ? "send first message"
                          : item.lastMessage!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font13LightGrayRegular,
                    ),
                  ],
                );
              } else {
                return Text(
                  item.lastMessage == ""
                      ? "send first message"
                      : item.lastMessage!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font13LightGrayRegular,
                );
              }
            } else {
              return Container();
            }
          }),
      trailing: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('groups')
              .doc(item.id)
              .collection('messages')
              .snapshots(),
          builder: (context, snapshot) {
            List<Message> unReadList = snapshot.data?.docs
                    .map((element) => Message.fromJson(element.data()))
                    .where((element) => element.read == '')
                    .where((element) =>
                        element.senderId !=
                        FirebaseAuth.instance.currentUser!.uid)
                    .toList() ??
                [];
            if (unReadList.isNotEmpty) {
              return Column(
                children: [
                  Text(
                    DateFormat.Hm()
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            int.parse(item.lastMessageTime!)))
                        .toString(),
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
                          unReadList.length.toString(),
                          style: TextStyles.font12WhiteSemiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text(
                DateFormat.Hm()
                    .format(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(item.lastMessageTime!)))
                    .toString(),
                style: TextStyles.font13LightGrayRegular,
              );
            }
          }),
    );
  }
}
