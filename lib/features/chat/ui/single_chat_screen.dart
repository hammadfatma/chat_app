import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/core/widgets/date_time.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:chat_app/features/chat/ui/widgets/circle_image.dart';
import 'package:chat_app/features/chat/ui/widgets/input_field.dart';
import 'package:chat_app/features/chat/ui/widgets/message_item.dart';
import 'package:chat_app/features/chat/ui/widgets/say_hello.dart';
import 'package:chat_app/features/chat/ui/widgets/show_date.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class SingleChatScreen extends StatefulWidget {
  const SingleChatScreen(
      {super.key, required this.roomId, required this.chatUser});
  final String roomId;
  final ChatUser chatUser;

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  TextEditingController messageController = TextEditingController();
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
            leading: CircleImage(image: widget.chatUser.image!),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatUser.name!,
                  style: TextStyles.font30WhiteBold.copyWith(fontSize: 16.sp),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.chatUser.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.data()!['online']
                            ? 'Online'
                            : "Last seen ${MyDateTime.dateAndTime(widget.chatUser.lastActivated!)} at ${MyDateTime.timeDate(widget.chatUser.lastActivated!)}",
                        style: TextStyles.font12WhiteSemiBold,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
            actions: selectedMessages.isNotEmpty
                ? [
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<ChatCubit>(context)
                            .deleteMessage(widget.roomId, selectedMessages);
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
                .collection('rooms')
                .doc(widget.roomId)
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
                            String newDate = '';
                            bool isSameDate = false;
                            if ((index == 0 && messageItems.length == 1) ||
                                index == messageItems.length - 1) {
                              newDate = MyDateTime.dateAndTime(
                                  messageItems[index].createdAt.toString());
                            } else {
                              final DateTime date = MyDateTime.dateFormat(
                                  messageItems[index].createdAt.toString());
                              final DateTime nextDate = MyDateTime.dateFormat(
                                  messageItems[index + 1].createdAt.toString());
                              isSameDate = date.isAtSameMomentAs(nextDate);
                              newDate = isSameDate
                                  ? ""
                                  : MyDateTime.dateAndTime(
                                      messageItems[index].createdAt.toString());
                            }
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
                              child: Column(
                                children: [
                                  if (newDate != '')
                                    Center(
                                      child: showDate(newDate),
                                    ),
                                  MessageItem(
                                    messageItem: messageItems[index],
                                    roomId: widget.roomId,
                                    isSelected: selectedMessages
                                        .contains(messageItems[index].id),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              verticalSpace(11),
                          itemCount: messageItems.length,
                        ),
                      ),
                      verticalSpace(25),
                      InputField(
                        controller: messageController,
                        onTapCamera: () {
                          context.pop();
                          BlocProvider.of<ChatCubit>(bcontext).sendImageToChat(
                              context: context,
                              imageSource: ImageSource.camera,
                              roomId: widget.roomId,
                              uid: widget.chatUser.id!);
                        },
                        onTapGallary: () {
                          context.pop();
                          BlocProvider.of<ChatCubit>(bcontext).sendImageToChat(
                              context: context,
                              imageSource: ImageSource.gallery,
                              roomId: widget.roomId,
                              uid: widget.chatUser.id!);
                        },
                        onPressedSend: () {
                          if (messageController.text.isNotEmpty) {
                            BlocProvider.of<ChatCubit>(context)
                                .sendMessage(
                              uid: widget.chatUser.id!,
                              msg: messageController.text,
                              roomId: widget.roomId,
                            )
                                .then(
                              (value) {
                                messageController.text = '';
                              },
                            );
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: GestureDetector(
                      onTap: () async {
                        await BlocProvider.of<ChatCubit>(context)
                            .createRoom(widget.chatUser.phone!)
                            .then(
                          (value) async {
                            await BlocProvider.of<ChatCubit>(context)
                                .sendMessage(
                              uid: widget.chatUser.id!,
                              msg: 'Hello 👋',
                              roomId: widget.roomId,
                            );
                          },
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
