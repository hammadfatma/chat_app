import 'package:chat_app/chat_app.dart';
import 'package:chat_app/core/routing/app_router.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String initialRoute = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = Routes.onBoardingScreen;
    } else {
      if (user.displayName == null || user.displayName == "") {
        initialRoute = Routes.initialProfileScreen;
      } else {
        initialRoute = Routes.homeScreen;
      }
    }
  });
  runApp(
    ChatApp(
      appRouter: AppRouter(),
    ),
  );
}
