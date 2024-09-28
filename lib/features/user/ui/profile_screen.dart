import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/font_weight_helper.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/core/widgets/progress_indicator.dart';
import 'package:chat_app/features/auth/logic/phone_cubit/phone_auth_cubit.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:chat_app/features/user/logic/cubit/user_cubit.dart';
import 'package:chat_app/features/user/ui/widgets/profile_image.dart';
import 'package:chat_app/features/user/ui/widgets/profile_list_tile.dart';
import 'package:chat_app/features/user/ui/widgets/show_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  final GlobalKey<FormState> _nameFormKey = GlobalKey();
  final GlobalKey<FormState> _aboutFormKey = GlobalKey();
  String editName = '';
  Future<void> _editName(BuildContext context, bcontext) async {
    if (!_nameFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _nameFormKey.currentState?.save();
      BlocProvider.of<UserCubit>(bcontext).editNameProfile(name: editName);
    }
  }

  String editAbout = '';
  Future<void> _editAbout(BuildContext context, bcontext) async {
    if (!_aboutFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _aboutFormKey.currentState?.save();
      BlocProvider.of<UserCubit>(bcontext).editAboutProfile(about: editAbout);
    }
  }

  @override
  Widget build(BuildContext bcontext) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyles.font20WhiteMedium.copyWith(
              fontWeight: FontWeightHelper.bold,
            ),
          ),
          actions: [
            BlocProvider<PhoneAuthCubit>(
              create: (context) => phoneAuthCubit,
              child: IconButton(
                onPressed: () async {
                  await phoneAuthCubit.logOut();
                  context.pushNamedAndRemoveUntil(Routes.loginScreen,predicate: (route) => false,);
                },
                icon: const Icon(
                  Icons.logout,
                  size: 20,
                  color: ColorsManager.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 32.h),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ChatUser me = ChatUser.fromJson(snapshot.data!.data()!);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pickImage(
                        context: context,
                        image: me.image,
                        onTapCamera: () async {
                          context.pop();
                          await BlocProvider.of<UserCubit>(bcontext)
                              .getProfileImage(ImageSource.camera)
                              .then((value) async {
                            await BlocProvider.of<UserCubit>(bcontext)
                                .editImageProfile();
                          });
                        },
                        onTapGallary: () async {
                          context.pop();
                          BlocProvider.of<UserCubit>(bcontext)
                              .getProfileImage(ImageSource.gallery)
                              .then((value) async {
                            await BlocProvider.of<UserCubit>(bcontext)
                                .editImageProfile();
                          });
                        },
                      ),
                      verticalSpace(66),
                      profileListTile(
                        leadingIcon: Icons.person,
                        titleText: 'Name',
                        subtitleText: me.name ?? '',
                        trailingEdit: () {
                          provideBottomSheet(
                            context: context,
                            onPressed: () {
                              showProgressIndicator(context);
                              _editName(context, bcontext);
                            },
                            key: _nameFormKey,
                            hintText: 'Enter your name',
                            buttonText: 'Edit your name',
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              editName = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your text!';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      verticalSpace(10),
                      const Divider(),
                      verticalSpace(10),
                      profileListTile(
                        leadingIcon: Icons.info_outline,
                        titleText: 'About',
                        subtitleText: me.about ?? '',
                        trailingEdit: () {
                          provideBottomSheet(
                            context: context,
                            onPressed: () {
                              showProgressIndicator(context);
                              _editAbout(context, bcontext);
                            },
                            key: _aboutFormKey,
                            hintText: 'Enter your about',
                            buttonText: 'Edit your about',
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              editAbout = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your text!';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      verticalSpace(10),
                      const Divider(),
                      verticalSpace(10),
                      profileListTile(
                        leadingIcon: Icons.call,
                        titleText: 'Phone',
                        subtitleText: me.phone ?? '',
                        isPhone: 'yes',
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.ligtGreen,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
