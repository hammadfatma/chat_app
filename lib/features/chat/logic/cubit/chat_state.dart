part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatcreatedLoadingState extends ChatState {}

class ChatcreatedSuccessState extends ChatState {}

class ChatcreatedFailureState extends ChatState {}
