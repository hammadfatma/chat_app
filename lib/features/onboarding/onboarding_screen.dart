import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 50.w, vertical: 25.h),
          child: Column(
            children: [
              Text(
                'Welcome to WhatsApp',
                style: TextStyles.font30WhiteBold,
              ),
              const Spacer(),
              Image.asset('assets/images/onboarding_image.png'),
              const Spacer(),
              Text(
                'Read our Privacy Policy. Tap "Agree and continue" to\n accept the Terms of Service.',
                textAlign: TextAlign.center,
                style: TextStyles.font13LightGrayRegular,
              ),
              verticalSpace(24),
              TextButton(
                onPressed: () {
                  context.pushNamed(Routes.loginScreen);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorsManager.ligtGreen),
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 40.h),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Text(
                  'AGREE AND CONTINUE',
                  style: TextStyles.font14BlackRegular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
