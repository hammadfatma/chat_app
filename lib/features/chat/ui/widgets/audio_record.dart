import 'dart:async';
import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:chat_app/features/group/logic/cubit/group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class AudioRecordWidget extends StatefulWidget {
  const AudioRecordWidget(
      {super.key,
      required this.postionId,
      this.userId,
      required this.bcontext});
  final String postionId;
  final String? userId;
  final BuildContext bcontext;
  @override
  State<AudioRecordWidget> createState() => _AudioRecordWidgetState();
}

class _AudioRecordWidgetState extends State<AudioRecordWidget> {
  final _myRecord = AudioRecorder();
  String _recorderTxt = '00:00:00';
  Timer? _recorderTimer;
  DateTime? _startTime;
  String path = '';
  bool isRecord = false;
  Future<void> startRecord() async {
    final location = await getApplicationDocumentsDirectory();
    String name = const Uuid().v1();
    if (await _myRecord.hasPermission()) {
      await _myRecord.start(const RecordConfig(),
          path: '${location.path}${name}m4a');
      _startTime = DateTime.now();
      _startRecordingTimer();
    }
    setState(() {
      isRecord = true;
    });
    print('start recording');
  }

  Future<void> stopRecord() async {
    String? finalPath = await _myRecord.stop();
    _recorderTimer?.cancel();
    setState(() {
      path = finalPath!;
      _recorderTxt = '00:00:00';
      isRecord = false;
    });
    if (widget.userId != null) {
      BlocProvider.of<ChatCubit>(widget.bcontext).sendAudioToChat(
        path: path,
        uid: widget.userId!,
        roomId: widget.postionId,
      );
    } else {
      BlocProvider.of<GroupCubit>(widget.bcontext).sendAudioToGroup(
        path: path,
        gropId: widget.postionId,
      );
    }
    print('stop recording');
  }

  void _startRecordingTimer() {
    _recorderTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final currentTime = DateTime.now();
      final duration = currentTime.difference(_startTime!);
      var date = DateTime.fromMillisecondsSinceEpoch(
        duration.inMilliseconds,
        isUtc: true,
      );
      var txt = DateFormat('mm:ss:SS').format(date);
      setState(() {
        _recorderTxt = txt.substring(0, 8);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startRecord();
  }

  @override
  void dispose() {
    _myRecord.dispose();
    _recorderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              _recorderTxt,
              style: TextStyles.font14BlackRegular,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isRecord
                    ? IconButton(
                        onPressed: () async {
                          await stopRecord();
                          context.pop();
                        },
                        icon: Transform.rotate(
                          angle: 3.14,
                          child: const Icon(
                            Icons.send,
                            size: 22,
                            color: ColorsManager.ligtGreen,
                          ),
                        ),
                      )
                    : Container(),
                isRecord
                    ? IconButton(
                        onPressed: () async {
                          await _myRecord.cancel();
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 22,
                          color: ColorsManager.gray,
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
