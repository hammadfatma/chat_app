import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class AudioPlayWidget extends StatefulWidget {
  const AudioPlayWidget({super.key, required this.audioUrl});
  final String audioUrl;
  @override
  State<AudioPlayWidget> createState() => _AudioPlayWidgetState();
}

class _AudioPlayWidgetState extends State<AudioPlayWidget> {
  bool _isPlay = false;
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Future<void> _playRecording(url) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isPlay = true;
    });
  }

  Future<void> _stopRecording() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlay = false;
      _position = Duration.zero;
    });
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (!_isPlay) {
                _playRecording(widget.audioUrl);
              } else {
                _stopRecording();
              }
            },
            icon: Icon(
              !_isPlay ? Icons.play_arrow : Icons.pause,
              size: 33,
              color: ColorsManager.gray,
            ),
          ),
        ),
        verticalSpace(10),
        Expanded(
          flex: 9,
          child: Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              }),
        ),
      ],
    );
  }
}
