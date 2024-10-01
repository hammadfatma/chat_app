import 'dart:io';

import 'package:chat_app/core/helpers/message_type.dart';
import 'package:chat_app/core/widgets/show_toast.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/data/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  Future<void> createRoom(String phone) async {
    emit(ChatcreatedLoadingState());
    QuerySnapshot userPhone = await firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .get();
    if (userPhone.docs.isNotEmpty) {
      String userId = userPhone.docs.first.id;
      // to avoid repeating the room chat between the same two user
      List<String> members = [myUid, userId]..sort((a, b) => a.compareTo(b));
      QuerySnapshot roomExist = await firestore
          .collection('rooms')
          .where('members', isEqualTo: members)
          .get();
      if (roomExist.docs.isEmpty) {
        ChatRoom chatRoom = ChatRoom(
            id: members.toString(),
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            members: members,
            lastMessage: "",
            lastMessageId: "",
            lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString());
        try {
          await firestore
              .collection('rooms')
              .doc(members.toString())
              .set(chatRoom.toJson());
          emit(ChatcreatedSuccessState());
        } catch (e) {
          emit(ChatcreatedFailureState());
        }
      }
    }
  }

  String? imageUrl;
  Future<void> sendImageToChat(
      {required ImageSource imageSource,
      required String roomId,
      required BuildContext context,
      required String uid}) async {
    // Request camera permission
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        emit(ImageSendToChatFailureState());
        showToast(text: 'Camera permission denied', state: ToastStates.error);
        return;
      }
    }
    emit(ImageSendToChatLoadingState());
    var file = await ImagePicker().pickImage(source: imageSource);
    if (file == null) return;
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('chat/$roomId');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);
    try {
      await referenceImageToUpload.putFile(
          File(file.path), SettableMetadata(contentType: 'image/png'));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      sendMessage(
          uid: uid,
          msg: imageUrl!,
          roomId: roomId,
          type: MessageType.image.name);
      emit(ImageSendToChatSuccessState());
    } catch (errorMsg) {
      showToast(text: 'No image selected', state: ToastStates.error);
      emit(ImageSendToChatFailureState());
    }
  }

  String? videoUrl;
  Future<void> sendVideoToChat(
      {required ImageSource imageSource,
      required String roomId,
      required BuildContext context,
      required String uid}) async {
    // Request camera permission
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        showToast(text: 'Camera permission denied', state: ToastStates.error);
        emit(VideoSendToChatFailureState('Camera permission denied'));
        return;
      }
    }
    emit(VideoSendToChatLoadingState());
    var file = await ImagePicker().pickVideo(source: imageSource);
    if (file == null) return;
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('chat/$roomId');
    Reference referenceImageToUpload = referenceDireImages.child(fileName);
    try {
      await referenceImageToUpload.putFile(
          File(file.path), SettableMetadata(contentType: 'video/mp4'));
      videoUrl = await referenceImageToUpload.getDownloadURL();
      sendMessage(
          uid: uid,
          msg: videoUrl!,
          roomId: roomId,
          type: MessageType.video.name);
      emit(VideoSendToChatSuccessState());
    } catch (errorMsg) {
      showToast(text: 'No video selected', state: ToastStates.error);
      emit(VideoSendToChatFailureState('No video selected'));
    }
  }

  Future<void> sendMessage({
    String? type,
    required String uid,
    required String msg,
    required String roomId,
  }) async {
    emit(MessageSendLoadingState());
    String msgId = const Uuid().v1();
    Message message = Message(
      id: msgId,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      receiverId: uid,
      senderId: myUid,
      msg: msg,
      type: type ?? 'text',
      read: '',
    );
    try {
      await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(msgId)
          .set(message.toJson());
      await firestore.collection('rooms').doc(roomId).update({
        'last_message_id': msgId,
        'last_message': type ?? msg,
        'last_message_time': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      emit(MessageSendSuccessState());
    } catch (e) {
      emit(MessageSendFailureState());
    }
  }

  Future<void> readMessage(
      {required String roomId, required String msgId}) async {
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    emit(MessageReadSuccessState());
  }

  Future<void> editMessage(
      {required String roomId,
      required String msgId,
      required String editMessage}) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('rooms').doc(roomId).get();
    var lastMessageId = documentSnapshot.get('last_message_id');
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .update({
      'msg': editMessage,
    });
    if (lastMessageId == msgId) {
      await firestore.collection('rooms').doc(roomId).update({
        'last_message': editMessage,
      });
    }
    emit(MessageEditSuccessState());
  }

  Future<void> deleteMessage(String roomId, List<String> msgs) async {
    var delmsgs = List<String>.from(msgs);
    DocumentSnapshot documentSnapshot =
        await firestore.collection('rooms').doc(roomId).get();
    var lastMessageId = documentSnapshot.get('last_message_id');
    for (var element in delmsgs) {
      await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(element)
          .delete();
      if (lastMessageId == element) {
        await firestore.collection('rooms').doc(roomId).update({
          'last_message': '⊘ This message was deleted',
          'last_message_time': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      }
    }
    emit(MessagedeletedSuccessState());
  }
}
