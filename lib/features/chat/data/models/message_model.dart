class Message {
  String? id;
  String? receiverId;
  String? senderId;
  String? msg;
  String? type;
  String? createdAt;
  String? read;

  Message({
    required this.id,
    required this.createdAt,
    required this.receiverId,
    required this.senderId,
    required this.msg,
    required this.type,
    required this.read,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      createdAt: json['created_at'],
      receiverId: json['receiver_id'],
      senderId: json['sender_id'],
      msg: json['msg'],
      read: json['read'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'receiver_id': receiverId,
      'sender_id': senderId,
      'msg': msg,
      'read': read,
      'type': type,
    };
  }
}
