import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(image),
      ),
    );
  }
}
