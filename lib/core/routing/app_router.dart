import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/auth/logic/phone_cubit/phone_auth_cubit.dart';
import 'package:chat_app/features/auth/ui/login_screen.dart';
import 'package:chat_app/features/auth/ui/otp_screen.dart';
import 'package:chat_app/features/chat/logic/cubit/chat_cubit.dart';
import 'package:chat_app/features/chat/ui/single_chat_screen.dart';
import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/features/onboarding/onboarding_screen.dart';
import 'package:chat_app/features/user/logic/cubit/user_cubit.dart';
import 'package:chat_app/features/user/ui/contacts_screen.dart';
import 'package:chat_app/features/user/ui/initial_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }
  Route? generateRoute(RouteSettings settings) {
    final argument = settings.arguments;
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: const LoginScreen(),
          ),
        );
      case Routes.otpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(
              phoneNumber: argument as String,
            ),
          ),
        );
      case Routes.initialProfileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UserCubit(),
            child: const InitialProfileScreen(),
          ),
        );
      case Routes.contactsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UserCubit(),
            child: const ContactsScreen(),
          ),
        );
      case Routes.singleChatScreen:
        return MaterialPageRoute(builder: (_) {
          SingleChatScreen args = argument as SingleChatScreen;
          return BlocProvider(
            create: (context) => ChatCubit(),
            child:
                SingleChatScreen(roomId: args.roomId, chatUser: args.chatUser),
          );
        });
      default:
        return null;
    }
  }
}
