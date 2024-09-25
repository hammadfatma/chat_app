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

// class ImageSendToChatLoadingState extends ChatState {
//   final void Function(BuildContext) showProgressIndicator;
//   ImageSendToChatLoadingState(this.showProgressIndicator);
// }

class ImageSendToChatSuccessState extends ChatState {}

class ImageSendToChatFailureState extends ChatState {}

class MessageReadSuccessState extends ChatState {}

class MessageEditSuccessState extends ChatState {}

class MessagedeletedSuccessState extends ChatState {}
