import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/font_weight_helper.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/auth/logic/phone_cubit/phone_auth_cubit.dart';
import 'package:chat_app/features/home/chats_screen.dart';
import 'package:chat_app/features/home/calls_screen.dart';
import 'package:chat_app/features/home/status_screen.dart';
import 'package:chat_app/features/home/widgets/floating_action.dart';
import 'package:chat_app/features/user/logic/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabIndex);
    BlocProvider.of<UserCubit>(context).updateActivate(online: true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString() == "AppLifecycleState.resumed") {
        BlocProvider.of<UserCubit>(context).updateActivate(online: true);
      } else if (message.toString() == "AppLifecycleState.paused" ||
          message.toString() == "AppLifecycleState.inactive") {
        BlocProvider.of<UserCubit>(context).updateActivate(online: false);
      }
      print("************$message**************");
      return Future.value(message);
    });
    super.initState();
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(
                  'If you want to chat with person, you should add him as contact and send hello message to him',
                ),
                actions: [
                  ListTile(
                    leading: const Icon(
                      Icons.contact_page,
                      size: 20,
                      color: ColorsManager.gray,
                    ),
                    title: const Text('Contacts'),
                    onTap: () {
                      context.pop();
                      context.pushNamed(Routes.contactsScreen);
                    },
                  ),
                ],
              ),
            );
          },
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
          title: Text(
            'WhatsApp',
            style: TextStyles.font20WhiteMedium
                .copyWith(fontWeight: FontWeightHelper.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.pushNamed(Routes.profileScreen);
              },
              icon: const Icon(
                Icons.person,
                size: 20,
                color: ColorsManager.white,
              ),
            ),
            IconButton(
              onPressed: () {
                context.pushNamed(Routes.groupsScreen);
              },
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
