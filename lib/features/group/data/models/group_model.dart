class ChatGroup {
  String? id;
  String? name;
  String? image;
  List? members;
  List? admins;
  String? lastMessage;
  String? lastMessageId;
  String? lastMessageTime;
  String? createdAt;
  ChatGroup({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.members,
    required this.admins,
    required this.lastMessage,
    required this.lastMessageId,
    required this.lastMessageTime,
  });
  factory ChatGroup.fromJson(Map<String, dynamic> json) {
    return ChatGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'],
      lastMessage: json['last_message'] ?? '',
      lastMessageId: json['last_message_id'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      members: json['members'] ?? [],
      admins: json['admins_id'] ?? [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'created_at': createdAt,
      'last_message': lastMessage,
      'last_message_id': lastMessageId,
      'last_message_time': lastMessageTime,
      'members': members,
      'admins_id': admins,
    };
  }
}
