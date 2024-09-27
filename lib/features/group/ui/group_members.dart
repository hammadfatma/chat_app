import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/group/data/models/group_model.dart';
import 'package:chat_app/features/group/logic/cubit/group_cubit.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupMembersScreen extends StatefulWidget {
  const GroupMembersScreen({super.key, required this.chatGroup});
  final ChatGroup chatGroup;

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.chatGroup.admins!
        .contains(FirebaseAuth.instance.currentUser!.uid);
    String myId = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Group members',
            style: TextStyles.font30WhiteBold.copyWith(fontSize: 16.sp),
          ),
          actions: [
            isAdmin
                ? IconButton(
                    onPressed: () {
                      context.pushNamed(
                        Routes.editGroupScreen,
                        arguments: widget.chatGroup,
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: ColorsManager.white,
                      size: 24,
                    ),
                  )
                : Container(),
          ],
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('id', whereIn: widget.chatGroup.members)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatUser> users = snapshot.data!.docs
                      .map((element) => ChatUser.fromJson(element.data()))
                      .toList();
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      bool admin =
                          widget.chatGroup.admins!.contains(users[index].id);
                      return ListTile(
                        title: Text(
                          users[index].name!,
                          style: TextStyles.font30WhiteBold
                              .copyWith(fontSize: 14.sp),
                        ),
                        subtitle: admin
                            ? Text(
                                'Admin',
                                style: TextStyles.font13LightGrayRegular
                                    .copyWith(color: ColorsManager.ligtGreen),
                              )
                            : Text(
                                'Member',
                                style: TextStyles.font13LightGrayRegular,
                              ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isAdmin && myId != users[index].id
                                ? IconButton(
                                    onPressed: () {
                                      admin
                                          ? BlocProvider.of<GroupCubit>(context)
                                              .removeAdmin(
                                                  gropId: widget.chatGroup.id!,
                                                  memberId: users[index].id!)
                                              .then((value) {
                                              setState(() {
                                                widget.chatGroup.admins!
                                                    .remove(users[index].id);
                                              });
                                            })
                                          : BlocProvider.of<GroupCubit>(context)
                                              .promptAdmin(
                                                  gropId: widget.chatGroup.id!,
                                                  memberId: users[index].id!)
                                              .then((value) {
                                              setState(() {
                                                widget.chatGroup.admins!
                                                    .add(users[index].id);
                                              });
                                            });
                                    },
                                    icon: const Icon(
                                      Icons.person,
                                      color: ColorsManager.white,
                                      size: 24,
                                    ),
                                  )
                                : Container(),
                            isAdmin && myId != users[index].id
                                ? IconButton(
                                    onPressed: () {
                                      BlocProvider.of<GroupCubit>(context)
                                          .removeMember(
                                              gropId: widget.chatGroup.id!,
                                              memberId: users[index].id!)
                                          .then((value) {
                                        setState(() {
                                          widget.chatGroup.members!
                                              .remove(users[index].id);
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: ColorsManager.white,
                                      size: 24,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => verticalSpace(33),
                    itemCount: users.length,
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
