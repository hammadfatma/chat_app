import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/font_weight_helper.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/core/widgets/progress_indicator.dart';
import 'package:chat_app/features/chat/ui/widgets/no_item_found.dart';
import 'package:chat_app/features/home/widgets/floating_action.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:chat_app/features/user/logic/cubit/user_cubit.dart';
import 'package:chat_app/features/user/ui/widgets/contact_item.dart';
import 'package:chat_app/features/user/ui/widgets/show_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool searched = false;
  final GlobalKey<FormState> _phoneFormKey = GlobalKey();
  String phoneNumber = '';
  TextEditingController searchController = TextEditingController();
  List myContacts = [];
  Future<void> _add(BuildContext context, bcontext) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState?.save();
      BlocProvider.of<UserCubit>(bcontext).addContact(phone: phoneNumber);
    }
  }

  @override
  Widget build(BuildContext bcontext) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: searched
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchController.text = value;
                          });
                        },
                        style: TextStyles.font12WhiteSemiBold,
                        autofocus: true,
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search by name",
                          hintStyle: TextStyles.font13LightGrayRegular,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  'Contacts',
                  style: TextStyles.font20WhiteMedium
                      .copyWith(fontWeight: FontWeightHelper.semiBold),
                ),
          actions: [
            searched
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        searched = false;
                        searchController.text = '';
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: ColorsManager.white,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        searched = true;
                      });
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 20,
                      color: ColorsManager.white,
                    ),
                  ),
          ],
        ),
        floatingActionButton: buildfloatingActionButton(
          onPressed: () {
            provideBottomSheet(
              context: context,
              onPressed: () {
                showProgressIndicator(context);
                _add(context, bcontext);
              },
              key: _phoneFormKey,
              hintText: "Enter Friend Phone",
              buttonText: 'Add Contact',
              keyboardType: TextInputType.phone,
              onSaved: (value) {
                phoneNumber = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter phone number!';
                } else if (!value.contains('+2')) {
                  return 'Please enter (+2) valid phone number!';
                } else if (value.length != 13) {
                  return 'It is not equal to the number of phone numbers!';
                }
                return null;
              },
            );
          },
          icon: Icons.person_add,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                myContacts = snapshot.data!.data()!['my_users'];
                if (myContacts.isEmpty) {
                  return noItemFound(typeName: 'contacts');
                } else {
                  return Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 5.w),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id',
                                whereIn: myContacts.isEmpty ? [''] : myContacts)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<ChatUser> items = snapshot.data!.docs
                                .map((element) =>
                                    ChatUser.fromJson(element.data()))
                                .where((element) => element.name!
                                    .toLowerCase()
                                    .startsWith(
                                        searchController.text.toLowerCase()))
                                .toList()
                              ..sort((a, b) => a.name!.compareTo(b.name!));
                            if (items.isEmpty) {
                              return noItemFound(
                                  typeName: 'contact with this name');
                            } else {
                              return ListView.separated(
                                itemBuilder: (context, index) {
                                  return ContactItem(
                                    user: items[index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    verticalSpace(33),
                                itemCount: items.length,
                              );
                            }
                          } else {
                            return Container();
                          }
                        }),
                  );
                }
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
