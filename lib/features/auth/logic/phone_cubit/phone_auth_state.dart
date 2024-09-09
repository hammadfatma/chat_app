part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}
class PhoneAuthLoading extends PhoneAuthState {}
class PhoneAuthError extends PhoneAuthState {
  final String error;

  PhoneAuthError(this.error);

}
class PhoneNumberSubmited extends PhoneAuthState {}
class PhoneOTPVerified extends PhoneAuthState {}
