part of 'profile_cubit.dart';

@immutable
class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileImagePickedSuccessState extends ProfileState {}

class ProfileImagePickedErrorState extends ProfileState {}

class ProfileCreateUserLoadingState extends ProfileState {}

class ProfileCreateUserSuccessState extends ProfileState {}

class ProfileCreateUserErrorState extends ProfileState {}
