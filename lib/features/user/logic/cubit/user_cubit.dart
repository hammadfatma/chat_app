import 'dart:io';

import 'package:chat_app/core/widgets/show_toast.dart';
import 'package:chat_app/features/user/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  String? imageUrl;
  Future<void> getProfileImage(ImageSource imageSource) async {
    var file = await ImagePicker().pickImage(source: imageSource);
    if (file == null) return;
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('profile');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);
    try {
      await referenceImageToUpload.putFile(
          File(file.path), SettableMetadata(contentType: 'image/png'));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      emit(ProfileImagePickedSuccessState());
    } catch (errorMsg) {
      showToast(text: 'No image selected', state: ToastStates.error);
      emit(ProfileImagePickedErrorState());
    }
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;
  Future<void> createUser() async {
    emit(ProfileCreateLoadingState());
    ChatUser chatUser = ChatUser(
      id: user.uid,
      name: user.displayName ?? "",
      phone: user.phoneNumber ?? "",
      about: 'Hey there! I am using WhatsApp.',
      image: imageUrl ??
          'https://firebasestorage.googleapis.com/v0/b/chat-app-95f3c.appspot.com/o/profile%2Fprofile_image.png?alt=media&token=98017798-3968-43b5-9124-0eb5b3e747bc',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      lastActivated: DateTime.now().millisecondsSinceEpoch.toString(),
      puchToken: '',
      online: false,
      myUsers: [],
    );
    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(chatUser.toJson());
      emit(ProfileCreateSuccessState());
    } catch (error) {
      emit(ProfileCreateErrorState());
    }
  }

  Future<void> editImageProfile() async {
    DocumentSnapshot document =
        await firebaseFirestore.collection('users').doc(user.uid).get();
    String imageValue = document.get('image');
    await firebaseFirestore.collection('users').doc(user.uid).update({
      'image': imageUrl ?? imageValue,
    });
    emit(ProfileImageEditSuccessState());
  }

  Future<void> editNameProfile({required String name}) async {
    await firebaseFirestore.collection('users').doc(user.uid).update({
      'name': name,
    });
    emit(ProfileNameEditSuccessState());
  }

  Future<void> editAboutProfile({required String about}) async {
    await firebaseFirestore.collection('users').doc(user.uid).update({
      'about': about,
    });
    emit(ProfileAboutEditSuccessState());
  }

  Future<void> addContact({required String phone}) async {
    emit(ContactCreateLoadingState());
    QuerySnapshot userPhone = await firebaseFirestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .get();
    if (userPhone.docs.isNotEmpty) {
      String userId = userPhone.docs.first.id;
      firebaseFirestore.collection('users').doc(user.uid).update({
        'my_users': FieldValue.arrayUnion([userId])
      });
      showToast(text: 'contact added', state: ToastStates.success);
      emit(ContactCreateSuccessState());
    } else {
      showToast(
          text: 'no found user has this phone number',
          state: ToastStates.error);
      emit(ContactCreateErrorState());
    }
  }
}
