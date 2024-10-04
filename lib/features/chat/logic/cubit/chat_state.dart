part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatcreatedLoadingState extends ChatState {}

class ChatcreatedSuccessState extends ChatState {}

class ChatcreatedFailureState extends ChatState {}

class MessageSendLoadingState extends ChatState {}

class MessageSendSuccessState extends ChatState {}

class MessageSendFailureState extends ChatState {}

class ImageSendToChatLoadingState extends ChatState {}

class ImageSendToChatSuccessState extends ChatState {}

class ImageSendToChatFailureState extends ChatState {}

class VideoSendToChatLoadingState extends ChatState {}

class VideoSendToChatSuccessState extends ChatState {}

class VideoSendToChatFailureState extends ChatState {}

class GifSendToChatLoadingState extends ChatState {}

class GifSendToChatSuccessState extends ChatState {}

class GifSendToChatFailureState extends ChatState {}

class AudioSendToChatLoadingState extends ChatState {}

class AudioSendToChatSuccessState extends ChatState {}

class AudioSendToChatFailureState extends ChatState {}

class MessageReadSuccessState extends ChatState {}

class MessageEditSuccessState extends ChatState {}

class MessagedeletedSuccessState extends ChatState {}
