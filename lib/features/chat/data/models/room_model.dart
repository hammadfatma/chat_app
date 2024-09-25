class ChatRoom {
  String? id;
  List? members;
  String? lastMessage;
  String? lastMessageId;
  String? lastMessageTime;
  String? createdAt;
  ChatRoom({
    required this.id,
    required this.createdAt,
    required this.members,
    required this.lastMessage,
    required this.lastMessageId,
    required this.lastMessageTime,
  });
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] ?? '',
      createdAt: json['created_at'],
      lastMessage: json['last_message'] ?? '',
      lastMessageId: json['last_message_id'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      members: json['members'] ?? [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'last_message': lastMessage,
      'last_message_id': lastMessageId,
      'last_message_time': lastMessageTime,
      'members': members,
    };
  }
}
