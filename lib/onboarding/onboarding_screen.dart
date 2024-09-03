import 'package:chat_app/theming/colors.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 50,vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to WhatsApp',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: ColorsManager.white,
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/onboarding_image.png'),
              const Spacer(),
              const Text(
                'Read our Privacy Policy. Tap "Agree and Continue" to\n accept the Terms of Service.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: ColorsManager.ligtGray,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorsManager.ligtGreen),
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 40),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: const Text(
                  'AGREE AND CONTINUE',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: ColorsManager.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
