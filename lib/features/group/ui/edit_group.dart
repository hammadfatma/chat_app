import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/theming/font_weight_helper.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/features/chat/ui/widgets/no_item_found.dart';
import 'package:chat_app/features/group/data/models/group_model.dart';
import 'package:chat_app/features/group/logic/cubit/group_cubit.dart';
import 'package:chat_app/features/home/widgets/floating_action.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:chat_app/features/user/ui/widgets/custom_text_field.dart';
import 'package:chat_app/features/user/ui/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditGroupScreen extends StatefulWidget {
  const EditGroupScreen({super.key, required this.chatGroup});
  final ChatGroup chatGroup;
  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  List<String> members = [];
  List myContacts = [];
  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.chatGroup.name!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Edit Group',
            style: TextStyles.font20WhiteMedium
                .copyWith(fontWeight: FontWeightHelper.bold),
          ),
        ),
        floatingActionButton: buildfloatingActionButton(
          onPressed: () {
            BlocProvider.of<GroupCubit>(context)
                .editGroup(
                    name: groupNameController.text,
                    members: members,
                    gropId: widget.chatGroup.id!)
                .then((value) {
              setState(() {
                widget.chatGroup.members!.addAll(members);
              });
              context.pop();
            });
          },
          icon: Icons.check_circle,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  pickImage(
                    context: context,
                    onTapCamera: () {
                      context.pop();
                      BlocProvider.of<GroupCubit>(context).pickImage(
                          imageSource: ImageSource.camera,
                          path: 'group',
                          context: context);
                    },
                    onTapGallary: () {
                      context.pop();
                      BlocProvider.of<GroupCubit>(context).pickImage(
                          imageSource: ImageSource.gallery,
                          path: 'group',
                          context: context);
                    },
                  ),
                  horizontalSpace(16),
                  Expanded(
                    child: CustomTextField(
                      controller: groupNameController,
                      hintText: 'Enter group name',
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              const Divider(),
              verticalSpace(16),
              Row(
                children: [
                  Text(
                    "Add Members",
                    style: TextStyles.font20WhiteMedium
                        .copyWith(fontWeight: FontWeightHelper.semiBold),
                  ),
                  const Spacer(),
                  Text(
                    "${members.length}",
                    style: TextStyles.font12WhiteSemiBold
                        .copyWith(fontWeight: FontWeightHelper.bold),
                  ),
                ],
              ),
              verticalSpace(16),
              Expanded(
                child: StreamBuilder(
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
                          padding:
                              EdgeInsetsDirectional.symmetric(horizontal: 5.w),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('id',
                                      whereIn: myContacts.isEmpty
                                          ? ['']
                                          : myContacts)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<ChatUser> items = snapshot
                                      .data!.docs
                                      .map((element) =>
                                          ChatUser.fromJson(element.data()))
                                      .where((element) =>
                                          element.id !=
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .where((element) => !widget
                                          .chatGroup.members!
                                          .contains(element.id))
                                      .toList()
                                    ..sort(
                                        (a, b) => a.name!.compareTo(b.name!));
                                  if (items.isEmpty) {
                                    return noItemFound(
                                        typeName: 'contact more');
                                  } else {
                                    return ListView.separated(
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          checkboxShape: const CircleBorder(),
                                          title: Text(
                                            items[index].name!,
                                            style: TextStyles.font20WhiteMedium,
                                          ),
                                          value:
                                              members.contains(items[index].id),
                                          onChanged: (value) {
                                            if (value!) {
                                              setState(() {
                                                members.add(items[index].id!);
                                              });
                                            } else {
                                              setState(() {
                                                members.remove(items[index].id);
                                              });
                                            }
                                          },
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
