import 'package:chat_app/features/chat/data/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          createdAt: DateTime.now().toString(),
          members: members,
          lastMessage: "",
          lastMessageTime: DateTime.now().toString(),
        );
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
}
