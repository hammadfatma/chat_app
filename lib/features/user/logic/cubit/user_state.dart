part of 'user_cubit.dart';

@immutable
class UserState {}

class UserInitial extends UserState {}

class ProfileImagePickedSuccessState extends UserState {}

class ProfileImagePickedErrorState extends UserState {}

class ProfileCreateLoadingState extends UserState {}

class ProfileCreateSuccessState extends UserState {}

class ProfileCreateErrorState extends UserState {}

class ContactCreateLoadingState extends UserState {}

class ContactCreateSuccessState extends UserState {}

class ContactCreateErrorState extends UserState {}
