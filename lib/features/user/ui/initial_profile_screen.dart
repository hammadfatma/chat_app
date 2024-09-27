import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/widgets/next_button.dart';
import 'package:chat_app/core/widgets/show_toast.dart';
import 'package:chat_app/features/auth/ui/widgets/intro_texts.dart';
import 'package:chat_app/core/widgets/progress_indicator.dart';
import 'package:chat_app/features/auth/ui/widgets/text_form_field.dart';
import 'package:chat_app/features/user/logic/cubit/user_cubit.dart';
import 'package:chat_app/features/user/ui/widgets/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class InitialProfileScreen extends StatefulWidget {
  const InitialProfileScreen({super.key});

  @override
  State<InitialProfileScreen> createState() => _InitialProfileScreenState();
}

class _InitialProfileScreenState extends State<InitialProfileScreen> {
  final GlobalKey<FormState> _nameFormKey = GlobalKey();
  late String name;
  Widget _buildNameFormField(bcontext) {
    return Column(
      children: [
        pickImage(
          context: context,
          onTapCamera: () {
            context.pop();
            BlocProvider.of<UserCubit>(bcontext)
                .getProfileImage(ImageSource.camera);
          },
          onTapGallary: () {
            context.pop();
            BlocProvider.of<UserCubit>(bcontext)
                .getProfileImage(ImageSource.gallery);
          },
        ),
        verticalSpace(16),
        showTextFormField(
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your name!';
            }
            return null;
          },
          onSaved: (value) {
            name = value!;
          },
        ),
      ],
    );
  }

  Future<void> _enterName(BuildContext context) async {
    if (!_nameFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _nameFormKey.currentState?.save();
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(name)
          .then((value) async {
        await BlocProvider.of<UserCubit>(context).createUser();
      });
    }
  }

  Widget _buildProfileCreatedBloc() {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is ProfileCreateLoadingState) {
          showProgressIndicator(context);
        }
        if (state is ProfileCreateSuccessState) {
          Navigator.pop(context);
          context.pushNamedAndRemoveUntil(
            Routes.homeScreen,
            predicate: (route) => false,
          );
          showToast(text: 'User Created', state: ToastStates.success);
        }
        if (state is ProfileCreateErrorState) {
          Navigator.pop(context);
          showToast(text: 'No User Created', state: ToastStates.error);
        }
      },
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext bcontext) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _nameFormKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 88.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildIntroTexts(
                    firstText: 'Profile Info',
                    secondText:
                        'Please enter your name and an optional profile photo.',
                  ),
                  verticalSpace(25),
                  _buildNameFormField(bcontext),
                  verticalSpace(150),
                  buildNextButton(
                    context,
                    text: 'Next',
                    onPressed: () {
                      showProgressIndicator(context);
                      _enterName(context);
                    },
                  ),
                  _buildProfileCreatedBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
