import 'package:chat_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoShowWidget extends StatefulWidget {
  const VideoShowWidget({super.key, required this.videoUrl});
  final String videoUrl;
  @override
  State<VideoShowWidget> createState() => _VideoShowWidgetState();
}

class _VideoShowWidgetState extends State<VideoShowWidget> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller?.setLooping(true);
    _controller?.initialize().then((value) {
      setState(() {});
    });
    //_controller?.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      return AspectRatio(
        // 16/9
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller!),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  },
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  )),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: ColorsManager.white,
        ),
      );
    }
  }
}
