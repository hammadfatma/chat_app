import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/features/chat/data/models/room_model.dart';
import 'package:chat_app/features/chat/ui/widgets/chat_item.dart';
import 'package:chat_app/features/chat/ui/widgets/no_item_found.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .where('members',
              arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ChatRoom> items = snapshot.data!.docs
              .map((element) => ChatRoom.fromJson(element.data()))
              .toList()
            ..sort(
              (a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),
            );
          if (items.isEmpty) {
            return noItemFound(typeName: 'chats');
          } else {
            return Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 5.w),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ChatItem(item: items[index]);
                },
                separatorBuilder: (context, index) => verticalSpace(33),
                itemCount: snapshot.data!.docs.length,
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
