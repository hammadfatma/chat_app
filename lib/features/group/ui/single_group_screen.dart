import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/ui/widgets/circle_image.dart';
import 'package:chat_app/features/chat/ui/widgets/say_hello.dart';
import 'package:chat_app/features/group/data/models/group_model.dart';
import 'package:chat_app/features/group/logic/cubit/group_cubit.dart';
import 'package:chat_app/features/group/ui/widgets/group_message_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class SingleGroupScreen extends StatefulWidget {
  const SingleGroupScreen({super.key, required this.chatGroup});
  final ChatGroup chatGroup;

  @override
  State<SingleGroupScreen> createState() => _SingleGroupScreenState();
}

class _SingleGroupScreenState extends State<SingleGroupScreen> {
  TextEditingController messageController = TextEditingController();
  bool messageWritten = false;
  List<String> selectedMessages = [];
  List<String> copiedMessages = [];
  @override
  Widget build(BuildContext bcontext) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: circleImage(image: widget.chatGroup.image!),
            title: GestureDetector(
              onTap: () {
                context.pushNamed(Routes.groupMembersScreen,
                    arguments: widget.chatGroup);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatGroup.name!,
                    style: TextStyles.font30WhiteBold.copyWith(fontSize: 16.sp),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('id', whereIn: widget.chatGroup.members)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List membersName = [];
                          for (var element in snapshot.data!.docs) {
                            membersName.add(element.data()['name']);
                          }
                          return Text(membersName.join(', '),
                              style: TextStyles.font12WhiteSemiBold);
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
            actions: selectedMessages.isNotEmpty
                ? [
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<GroupCubit>(context).deleteMessage(
                            widget.chatGroup.id!, selectedMessages);
                        setState(() {
                          selectedMessages.clear();
                          copiedMessages.clear();
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: ColorsManager.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: copiedMessages.join(' \n')));
                        setState(() {
                          selectedMessages.clear();
                          copiedMessages.clear();
                        });
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: ColorsManager.white,
                        size: 24,
                      ),
                    ),
                  ]
                : [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.videocam,
                        color: ColorsManager.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        color: ColorsManager.white,
                        size: 24,
                      ),
                    ),
                  ],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(widget.chatGroup.id)
                .collection('messages')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Message> messageItems = snapshot.data!.docs
                    .map((element) => Message.fromJson(element.data()))
                    .toList()
                  ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                if (messageItems.isNotEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          reverse: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMessages.isNotEmpty
                                      ? selectedMessages
                                              .contains(messageItems[index].id)
                                          ? selectedMessages
                                              .remove(messageItems[index].id)
                                          : selectedMessages
                                              .add(messageItems[index].id!)
                                      : null;
                                  copiedMessages.isNotEmpty
                                      ? messageItems[index].type == 'text'
                                          ? copiedMessages.contains(
                                                  messageItems[index].msg)
                                              ? copiedMessages.remove(
                                                  messageItems[index].msg)
                                              : copiedMessages
                                                  .add(messageItems[index].msg!)
                                          : null
                                      : null;
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  selectedMessages
                                          .contains(messageItems[index].id)
                                      ? selectedMessages
                                          .remove(messageItems[index].id)
                                      : selectedMessages
                                          .add(messageItems[index].id!);
                                  messageItems[index].type == 'text'
                                      ? copiedMessages
                                              .contains(messageItems[index].msg)
                                          ? copiedMessages
                                              .remove(messageItems[index].msg)
                                          : copiedMessages
                                              .add(messageItems[index].msg!)
                                      : null;
                                });
                              },
                              child: GroupMessageItem(
                                messageItem: messageItems[index],
                                groupId: widget.chatGroup.id!,
                                isSelected: selectedMessages
                                    .contains(messageItems[index].id),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              verticalSpace(11),
                          itemCount: messageItems.length,
                        ),
                      ),
                      verticalSpace(25),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: ColorsManager.darkGray,
                              ),
                              child: TextField(
                                controller: messageController,
                                onChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      messageWritten = true;
                                    });
                                  } else {
                                    setState(() {
                                      messageWritten = false;
                                    });
                                  }
                                },
                                style: TextStyles.font14BlackRegular
                                    .copyWith(color: ColorsManager.white),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  hintText: 'Message',
                                  hintStyle: TextStyles.font13LightGrayRegular,
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.mood,
                                      size: 20,
                                      color: ColorsManager.ligtGray,
                                    ),
                                  ),
                                  suffixIcon: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.attach_file,
                                          size: 20,
                                          color: ColorsManager.ligtGray,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'choose what you want'),
                                              actions: [
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.camera),
                                                  title: const Text('Camera'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    BlocProvider.of<
                                                                GroupCubit>(
                                                            bcontext)
                                                        .sendImageToGroup(
                                                            imageSource:
                                                                ImageSource
                                                                    .camera,
                                                            gropId: widget
                                                                .chatGroup.id!,
                                                            context: context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.image),
                                                  title: const Text('Gallery'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    BlocProvider.of<
                                                                GroupCubit>(
                                                            bcontext)
                                                        .sendImageToGroup(
                                                            imageSource:
                                                                ImageSource
                                                                    .gallery,
                                                            gropId: widget
                                                                .chatGroup.id!,
                                                            context: context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.photo_camera,
                                          size: 20,
                                          color: ColorsManager.ligtGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          horizontalSpace(10),
                          ClipOval(
                            child: Container(
                              height: 50.h,
                              width: 50.w,
                              color: ColorsManager.ligtGreen,
                              child: messageWritten
                                  ? IconButton(
                                      onPressed: () {
                                        if (messageController.text.isNotEmpty) {
                                          BlocProvider.of<GroupCubit>(context)
                                              .sendGroupMessage(
                                                  msg: messageController.text,
                                                  gropId: widget.chatGroup.id!)
                                              .then(
                                            (value) {
                                              messageController.text = '';
                                            },
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        size: 22,
                                        color: ColorsManager.white,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.mic,
                                        size: 22,
                                        color: ColorsManager.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: GestureDetector(
                      onTap: () async {
                        await BlocProvider.of<GroupCubit>(context)
                            .sendGroupMessage(
                          msg: 'Hello 👋',
                          gropId: widget.chatGroup.id!,
                        );
                      },
                      child: const SayHello(),
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
