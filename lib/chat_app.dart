import 'package:chat_app/core/routing/app_router.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorsManager.ligtGreen),
          useMaterial3: true,
          scaffoldBackgroundColor: ColorsManager.black,
          fontFamily: 'Roboto',
        ),
        initialRoute: initialRoute,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
