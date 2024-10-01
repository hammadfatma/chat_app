import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/core/widgets/date_time.dart';
import 'package:chat_app/core/widgets/progress_indicator.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/ui/widgets/video_player.dart';
import 'package:chat_app/features/group/logic/cubit/group_cubit.dart';
import 'package:chat_app/features/user/ui/widgets/show_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupMessageItem extends StatefulWidget {
  const GroupMessageItem({
    super.key,
    required this.messageItem,
    required this.groupId,
    required this.isSelected,
  });
  final Message messageItem;
  final String groupId;
  final bool isSelected;
  @override
  State<GroupMessageItem> createState() => _GroupMessageItemState();
}

class _GroupMessageItemState extends State<GroupMessageItem> {
  final GlobalKey<FormState> _textFormKey = GlobalKey();
  String editText = '';
  Future<void> _edit(BuildContext context, bcontext) async {
    if (!_textFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _textFormKey.currentState?.save();
      BlocProvider.of<GroupCubit>(bcontext).editMessage(
          gropId: widget.groupId,
          msgId: widget.messageItem.id!,
          editMessage: editText);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.messageItem.senderId != FirebaseAuth.instance.currentUser!.uid) {
      BlocProvider.of<GroupCubit>(context)
          .readMessage(gropId: widget.groupId, msgId: widget.messageItem.id!);
    }
  }

  Widget _messageType() {
    switch (widget.messageItem.type) {
      case 'image':
        return GestureDetector(
          onTap: () {
            context.pushNamed(
              Routes.photoViewScreen,
              arguments: widget.messageItem.msg,
            );
          },
          child: Image.network(
            widget.messageItem.msg!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.white,
                ),
              );
            },
          ),
        );
      case 'video':
        return VideoShowWidget(videoUrl: widget.messageItem.msg!);
      case 'text':
        return Text(
          widget.messageItem.msg!,
          style: TextStyles.font14BlackRegular
              .copyWith(color: ColorsManager.white),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext bcontext) {
    bool isMe =
        widget.messageItem.senderId == FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration: BoxDecoration(
        color: widget.isSelected ? ColorsManager.ligtGray : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.messageItem.senderId)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    isMe
                        ? widget.messageItem.type == 'text'
                            ? IconButton(
                                onPressed: () {
                                  provideBottomSheet(
                                    context: context,
                                    onPressed: () {
                                      showProgressIndicator(context);
                                      _edit(context, bcontext);
                                    },
                                    key: _textFormKey,
                                    hintText: "Enter your text",
                                    buttonText: 'Edit text',
                                    keyboardType: TextInputType.text,
                                    onSaved: (value) {
                                      editText = value!;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your text!';
                                      }
                                      return null;
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: ColorsManager.white,
                                ),
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(16),
                          bottomRight: const Radius.circular(16),
                          topLeft: Radius.circular(isMe ? 16 : 0),
                          topRight: Radius.circular(isMe ? 0 : 16),
                        ),
                      ),
                      color: isMe
                          ? ColorsManager.ligtGreen
                          : ColorsManager.darkGray,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.sizeOf(context).width / 2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              !isMe
                                  ? snapshot.hasData
                                      ? Text(
                                          snapshot.data!.data()!['name'],
                                          style:
                                              TextStyles.font13LightGrayRegular,
                                        )
                                      : Container()
                                  : const SizedBox(),
                              _messageType(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isMe
                                      ? Icon(
                                          Icons.done_all,
                                          color: widget.messageItem.read == ''
                                              ? ColorsManager.ligtGray
                                              : ColorsManager.blue,
                                          size: 18,
                                        )
                                      : const SizedBox(),
                                  horizontalSpace(6),
                                  Text(
                                    MyDateTime.timeDate(
                                        widget.messageItem.createdAt!),
                                    style: TextStyles.font13LightGrayRegular,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }
}
