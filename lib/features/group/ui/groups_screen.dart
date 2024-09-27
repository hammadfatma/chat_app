import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/font_weight_helper.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/ui/widgets/no_item_found.dart';
import 'package:chat_app/features/group/data/models/group_model.dart';
import 'package:chat_app/features/group/ui/widgets/group_item.dart';
import 'package:chat_app/features/home/widgets/floating_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Groups',
            style: TextStyles.font20WhiteMedium
                .copyWith(fontWeight: FontWeightHelper.bold),
          ),
        ),
        floatingActionButton: buildfloatingActionButton(
          onPressed: () {
            context.pushNamed(Routes.createGroupScreen);
          },
          icon: Icons.group_add,
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .where('members',
                      arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatGroup> items = snapshot.data!.docs
                      .map((element) => ChatGroup.fromJson(element.data()))
                      .toList()
                    ..sort((a, b) =>
                        b.lastMessageTime!.compareTo(a.lastMessageTime!));
                  if (items.isNotEmpty) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return GroupItem(item: items[index]);
                      },
                      separatorBuilder: (context, index) => verticalSpace(33),
                      itemCount: items.length,
                    );
                  } else {
                    return noItemFound(typeName: 'Groups');
                  }
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
