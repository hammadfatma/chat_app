import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/font_weight_helper.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/auth/logic/phone_cubit/phone_auth_cubit.dart';
import 'package:chat_app/features/chat/ui/chats_screen.dart';
import 'package:chat_app/features/chat/ui/calls_screen.dart';
import 'package:chat_app/features/chat/ui/status_screen.dart';
import 'package:chat_app/features/home/widgets/floating_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  Widget _floatingButton() {
    switch (_tabController.index) {
      case 0:
        return buildfloatingActionButton(
          onPressed: () {},
          icon: Icons.chat,
        );
      case 1:
        return buildfloatingActionButton(
          onPressed: () {},
          icon: Icons.photo_camera,
        );
      case 2:
        return buildfloatingActionButton(
          onPressed: () {},
          icon: Icons.phone,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'WhatsApp',
            style: TextStyles.font20WhiteMedium
                .copyWith(fontWeight: FontWeightHelper.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.pushNamed(Routes.contactsScreen);
              },
              icon: const Icon(
                Icons.contact_page,
                size: 20,
                color: ColorsManager.white,
              ),
            ),
            BlocProvider<PhoneAuthCubit>(
              create: (context) => phoneAuthCubit,
              child: IconButton(
                onPressed: () async {
                  await phoneAuthCubit.logOut();
                  context.pushReplacementNamed(Routes.loginScreen);
                },
                icon: const Icon(
                  Icons.person,
                  size: 20,
                  color: ColorsManager.white,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.groups,
                size: 20,
                color: ColorsManager.white,
              ),
            ),
          ],
        ),
        floatingActionButton: _floatingButton(),
        body: Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(surfaceVariant: Colors.transparent),
              ),
              child: SizedBox(
                height: 100.h,
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Text(
                      'CHATS',
                      style:
                          TextStyles.font30WhiteBold.copyWith(fontSize: 14.sp),
                    ),
                    Text(
                      'STATUS',
                      style:
                          TextStyles.font30WhiteBold.copyWith(fontSize: 14.sp),
                    ),
                    Text(
                      'Calls',
                      style:
                          TextStyles.font30WhiteBold.copyWith(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ChatsScreen(),
                  StatusScreen(),
                  CallsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
