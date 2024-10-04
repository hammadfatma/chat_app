part of 'group_cubit.dart';

@immutable
abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupcreatedLoadingState extends GroupState {}

class GroupcreatedSuccessState extends GroupState {}

class GroupcreatedFailureState extends GroupState {}

class MessageGroupSendLoadingState extends GroupState {}

class MessageGroupSendSuccessState extends GroupState {}

class MessageGroupSendFailureState extends GroupState {}

class MessageReadSuccessState extends GroupState {}

class MessageEditSuccessState extends GroupState {}

class MessagedeletedSuccessState extends GroupState {}

class GroupImageSendLoadingState extends GroupState {}

class GroupImageSendSuccessState extends GroupState {}

class GroupImageSendFailureState extends GroupState {}

class GroupVideoSendLoadingState extends GroupState {}

class GroupVideoSendSuccessState extends GroupState {}

class GroupVideoSendFailureState extends GroupState {}

class GroupGifSendLoadingState extends GroupState {}

class GroupGifSendSuccessState extends GroupState {}

class GroupGifSendFailureState extends GroupState {}

class GroupAudioSendLoadingState extends GroupState {}

class GroupAudioSendSuccessState extends GroupState {}

class GroupAudioSendFailureState extends GroupState {}

class GroupImagePickedSuccessState extends GroupState {}

class GroupImagePickedErrorState extends GroupState {}

class GroupeditSuccessState extends GroupState {}

class MemberRemovedSuccessState extends GroupState {}

class AdminPrompetSuccessState extends GroupState {}

class AdminRemovedSuccessState extends GroupState {}
