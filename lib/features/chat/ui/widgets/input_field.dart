import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/ui/widgets/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatefulWidget {
  InputField({
    super.key,
    this.controller,
    this.onTapImageCamera,
    this.onTapImageGallary,
    this.onPressedSend,
    this.onTapVideoCamera,
    this.onTapVideoGallary,
    this.onTapGif,
  });
  final TextEditingController? controller;
  final void Function()? onTapImageCamera;
  final void Function()? onTapImageGallary;
  final void Function()? onTapVideoCamera;
  final void Function()? onTapVideoGallary;
  final void Function()? onTapGif;
  final void Function()? onPressedSend;
  final focusNode = FocusNode();
  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool messageWritten = false;
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  Future<void> toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  Future<bool> onBackPressed() async {
    if (isEmojiVisible) {
      toggleEmojiKeyboard();
    } else {
      context.pop();
    }
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });
      if (isKeyboardVisible && isEmojiVisible) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Column(
        children: [
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
                    focusNode: widget.focusNode,
                    controller: widget.controller,
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
                        onPressed: () async {
                          if (isEmojiVisible) {
                            widget.focusNode.requestFocus();
                          } else if (isKeyboardVisible) {
                            await SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                          }
                          toggleEmojiKeyboard();
                        },
                        icon: Icon(
                          isEmojiVisible
                              ? Icons.keyboard_rounded
                              : Icons.emoji_emotions_outlined,
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
                                  title: const Text('choose what you want'),
                                  actions: [
                                    ListTile(
                                      leading: const Icon(Icons.camera),
                                      title: const Text('Image with Camera'),
                                      onTap: widget.onTapImageCamera,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.image),
                                      title: const Text('Image from Gallery'),
                                      onTap: widget.onTapImageGallary,
                                    ),
                                    ListTile(
                                      leading:
                                          const Icon(Icons.video_camera_front),
                                      title: const Text('video with Camera'),
                                      onTap: widget.onTapVideoCamera,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.video_file),
                                      title: const Text('video from Gallery'),
                                      onTap: widget.onTapVideoGallary,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.gif_box),
                                      title: const Text('Gif'),
                                      onTap: widget.onTapGif,
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
                          onPressed: widget.onPressedSend,
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
          OffstageEmoji(
            isEmojiVisible: isEmojiVisible,
            messageController: widget.controller,
          ),
        ],
      ),
    );
  }
}
