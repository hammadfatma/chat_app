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
import 'package:chat_app/features/auth/ui/widgets/text_form_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _phoneFormKey = GlobalKey();
  late String phoneNumber;
  String contryName = '';
  String contryFlag = '';
  String contryCode = '';
  Widget _buildPhoneFormField() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ColorsManager.ligtGreen),
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contryName == '' ? 'Pick Country' : contryName,
                textAlign: TextAlign.center,
                style: TextStyles.font14BlackRegular
                    .copyWith(color: ColorsManager.white),
              ),
              IconButton(
                onPressed: () {
                  pickCountry();
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: ColorsManager.white,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorsManager.ligtGreen),
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide.none,
                  ),
                ),
                child: Text(
                  '$contryFlag +$contryCode',
                  style: TextStyles.font14BlackRegular
                      .copyWith(color: ColorsManager.white),
                ),
              ),
            ),
            horizontalSpace(16),
            Expanded(
              flex: 2,
              child: showTextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number!';
                  } else if (value.length < 11) {
                    return 'Too short for a phone number!';
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value!;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void pickCountry() {
    showCountryPicker(
        showPhoneCode: true,
        context: context,
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
          bottomSheetHeight: 500, // Optional. Country list modal height
          //Optional. Sets the border radius for the bottomsheet.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Start typing to search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF8C98A8).withOpacity(0.2),
              ),
            ),
          ),
        ),
        onSelect: (Country country) {
          print('Select country: ${country.displayName}');
          setState(() {
            contryName = country.name;
            contryFlag = country.flagEmoji;
            contryCode = country.phoneCode;
          });
        });
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState?.save();
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }

  Widget _buildPhoneNumberSubmitedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is PhoneAuthLoading) {
          showProgressIndicator(context);
        }
        if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          context.pushNamed(Routes.otpScreen, arguments: phoneNumber);
        }
        if (state is PhoneAuthError) {
          Navigator.pop(context);
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
        body: Form(
          key: _phoneFormKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 88.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildIntroTexts(
                    firstText: 'What is your phone number?',
                    secondText:
                        'Please enter your phone number to verify your account.',
                  ),
                  verticalSpace(25),
                  _buildPhoneFormField(),
                  verticalSpace(150),
                  buildNextButton(
                    context,
                    text: 'Next',
                    onPressed: () {
                      showProgressIndicator(context);
                      _register(context);
                    },
                  ),
                  _buildPhoneNumberSubmitedBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
