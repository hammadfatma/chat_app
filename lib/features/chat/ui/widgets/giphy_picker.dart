import 'package:chat_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

class GifPickWidget extends StatelessWidget {
  const GifPickWidget({super.key, required this.gifUrl});
  final String gifUrl;

  @override
  Widget build(BuildContext context) {
    return GiphyImage(
      url: gifUrl,
      placeholder: const Center(
        child: CircularProgressIndicator(
          color: ColorsManager.white,
        ),
      ),
    );
  }
}
