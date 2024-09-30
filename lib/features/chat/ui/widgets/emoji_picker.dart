import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiPickerWidget extends StatelessWidget {
  const EmojiPickerWidget(
      {super.key,
      this.onEmojiSelected,
      this.onBackspacePressed,
      this.textEditingController});
  final void Function(Category?, Emoji)? onEmojiSelected;
  final void Function()? onBackspacePressed;
  final TextEditingController? textEditingController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .35,
      child: EmojiPicker(
        textEditingController: textEditingController,
        onBackspacePressed: onBackspacePressed,
        onEmojiSelected: (category, emoji) => onEmojiSelected,
      ),
    );
  }
}

class OffstageEmoji extends StatefulWidget {
  const OffstageEmoji({
    super.key,
    required this.isEmojiVisible,
    this.messageController,
  });
  final bool isEmojiVisible;
  final TextEditingController? messageController;
  @override
  State<OffstageEmoji> createState() => _OffstageEmojiState();
}

class _OffstageEmojiState extends State<OffstageEmoji> {
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !widget.isEmojiVisible,
      child: EmojiPickerWidget(
        textEditingController: widget.messageController,
        onEmojiSelected: (category, emoji) {
          setState(() {
            widget.messageController?.text =
                widget.messageController!.text + emoji.emoji.toString();
          });
        },
      ),
    );
  }
}
