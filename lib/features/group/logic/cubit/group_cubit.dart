import 'dart:io';
import 'package:chat_app/core/widgets/show_toast.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/group/data/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  String now = DateTime.now().millisecondsSinceEpoch.toString();
  Future<void> createGroup({
    required String name,
    required List members,
  }) async {
    emit(GroupcreatedLoadingState());
    String gId = const Uuid().v1();
    members.add(myUid);
    ChatGroup chatGroup = ChatGroup(
      id: gId,
      name: name,
      image: imageUrl ??
          'https://firebasestorage.googleapis.com/v0/b/chat-app-95f3c.appspot.com/o/group%2Fimages.jpeg?alt=media&token=534c4087-8610-4051-a849-5c0d245920e0',
      createdAt: now,
      members: members,
      admins: [myUid],
      lastMessage: '',
      lastMessageId: '',
      lastMessageTime: now,
    );
    try {
      await firestore.collection('groups').doc(gId).set(chatGroup.toJson());
      emit(GroupcreatedSuccessState());
    } catch (e) {
      emit(GroupcreatedFailureState());
    }
  }

  String? imageUrl;
  Future<void> pickImage({
    required ImageSource imageSource,
    required String path,
    required BuildContext context,
  }) async {
    var file = await ImagePicker().pickImage(source: imageSource);
    if (file == null) return;
    //String ext = file.path.split('.').last;
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('$path/');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);
    try {
      await referenceImageToUpload.putFile(
          File(file.path), SettableMetadata(contentType: 'image/png'));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      emit(GroupImagePickedSuccessState());
    } catch (errorMsg) {
      showToast(text: 'No image selected', state: ToastStates.error);
      emit(GroupImagePickedErrorState());
    }
  }

  Future<void> sendImageToGroup({
    required ImageSource imageSource,
    required String gropId,
    required BuildContext context,
  }) async {
    await pickImage(
        imageSource: imageSource, path: 'group/$gropId', context: context);
    try {
      await sendGroupMessage(msg: imageUrl!, gropId: gropId, type: 'image');
      emit(GroupImageSendSuccessState());
    } catch (e) {
      emit(GroupImageSendFailureState());
    }
  }

  Future<void> sendGroupMessage({
    String? type,
    required String msg,
    required String gropId,
  }) async {
    emit(MessageGroupSendLoadingState());
    String msgId = const Uuid().v1();
    Message message = Message(
      id: msgId,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      receiverId: '',
      senderId: myUid,
      msg: msg,
      type: type ?? 'text',
      read: '',
    );
    try {
      await firestore
          .collection('groups')
          .doc(gropId)
          .collection('messages')
          .doc(msgId)
          .set(message.toJson());
      await firestore.collection('groups').doc(gropId).update({
        'last_message_id': msgId,
        'last_message': type ?? msg,
        'last_message_time': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      emit(MessageGroupSendSuccessState());
    } catch (e) {
      emit(MessageGroupSendFailureState());
    }
  }

  Future<void> readMessage(
      {required String gropId, required String msgId}) async {
    await firestore
        .collection('groups')
        .doc(gropId)
        .collection('messages')
        .doc(msgId)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    emit(MessageReadSuccessState());
  }

  Future<void> editMessage(
      {required String gropId,
      required String msgId,
      required String editMessage}) async {
    await firestore
        .collection('groups')
        .doc(gropId)
        .collection('messages')
        .doc(msgId)
        .update({
      'msg': editMessage,
    });
    emit(MessageEditSuccessState());
  }

  Future<void> deleteMessage(String gropId, List<String> msgs) async {
    var delmsgs = List<String>.from(msgs);
    DocumentSnapshot documentSnapshot =
        await firestore.collection('groups').doc(gropId).get();
    var lastMessageId = documentSnapshot.get('last_message_id');
    for (var element in delmsgs) {
      await firestore
          .collection('groups')
          .doc(gropId)
          .collection('messages')
          .doc(element)
          .delete();
      if (lastMessageId == element) {
        await firestore.collection('groups').doc(gropId).update({
          'last_message': '⊘ This message was deleted',
          'last_message_time': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      }
    }
    emit(MessagedeletedSuccessState());
  }

  Future<void> editGroup(
      {required String gropId,
      required String name,
      required List members}) async {
    DocumentSnapshot document =
        await firestore.collection('groups').doc(gropId).get();
    String imageValue = document.get('image');
    await firestore.collection('groups').doc(gropId).update({
      'image': imageUrl ?? imageValue,
      'name': name,
      'members': FieldValue.arrayUnion(members)
    });
    emit(GroupeditSuccessState());
  }

  Future<void> removeMember(
      {required String gropId, required String memberId}) async {
    await firestore.collection('groups').doc(gropId).update({
      'members': FieldValue.arrayRemove([memberId])
    });
    emit(MemberRemovedSuccessState());
  }

  Future<void> promptAdmin(
      {required String gropId, required String memberId}) async {
    await firestore.collection('groups').doc(gropId).update({
      'admins_id': FieldValue.arrayUnion([memberId])
    });
    emit(AdminPrompetSuccessState());
  }

  Future<void> removeAdmin(
      {required String gropId, required String memberId}) async {
    await firestore.collection('groups').doc(gropId).update({
      'admins_id': FieldValue.arrayRemove([memberId])
    });
    emit(AdminRemovedSuccessState());
  }
}
