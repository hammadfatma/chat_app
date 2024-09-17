import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/core/widgets/show_toast.dart';
import 'package:chat_app/features/auth/logic/phone_cubit/phone_auth_cubit.dart';
import 'package:chat_app/core/widgets/next_button.dart';
import 'package:chat_app/features/auth/ui/widgets/intro_texts.dart';
import 'package:chat_app/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String otpCode;
  Widget _buildPinCodeFields(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      autoFocus: true,
      cursorColor: ColorsManager.ligtGreen,
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50.h,
        fieldWidth: 40.w,
        borderWidth: 1,
        activeColor: ColorsManager.white,
        inactiveColor: ColorsManager.white,
        inactiveFillColor: ColorsManager.black,
        activeFillColor: ColorsManager.black,
        selectedColor: ColorsManager.white,
        selectedFillColor: ColorsManager.black,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: ColorsManager.black,
      enableActiveFill: true,
      textStyle: TextStyles.font20WhiteMedium,
      onCompleted: (submitedCode) {
        otpCode = submitedCode;
        print("Completed");
      },
      onChanged: (value) {},
    );
  }

  void _login(BuildContext context) {
    BlocProvider.of<PhoneAuthCubit>(context).submitOTP(otpCode);
  }

  Widget _buildPhoneVerificationBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is PhoneAuthLoading) {
          showProgressIndicator(context);
        }
        if (state is PhoneOTPVerified) {
          Navigator.pop(context);
          context.pushNamedAndRemoveUntil(
            Routes.initialProfileScreen,
            predicate: (route) => false,
          );
        }
        if (state is PhoneAuthError) {
          String errorMsg = state.error;
          showToast(text: errorMsg, state: ToastStates.error);
        }
      },
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 88.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildIntroTexts(
                firstText: 'Verify your phone number',
                secondText:
                    'Enter your 6 digit code numbers sent to ${widget.phoneNumber}',
              ),
              verticalSpace(88),
              _buildPinCodeFields(context),
              verticalSpace(60),
              buildNextButton(
                context,
                text: 'Verify',
                onPressed: () {
                  showProgressIndicator(context);
                  _login(context);
                },
              ),
              _buildPhoneVerificationBloc(),
            ],
          ),
        ),
      ),
    );
  }
}
