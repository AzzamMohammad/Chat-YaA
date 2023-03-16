import 'dart:convert';

Chats chatsFromJson(String str) => Chats.fromJson(json.decode(str));

String chatsToJson(Chats data) => json.encode(data.toJson());

class Chats {
  Chats({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  dynamic data;

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:json["Data"] != null ? List<chat>.from(json["Data"].map((x) => chat.fromJson(x))):<chat>[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class chat {
  chat({
    required this.chatId,
    required this.user1,
    required this.user2,
    required this.createdAt,
    required this.updatedAt,
    required this.phone,
    required this.name,
  });

  int chatId;
  int user1;
  int user2;
  DateTime createdAt;
  DateTime updatedAt;
  int phone;
  String name;

  factory chat.fromJson(Map<String, dynamic> json) => chat(
    chatId: json["chat_id"],
    user1: json["user_1"],
    user2: json["user_2"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    phone: json["phone"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "chat_id": chatId,
    "user_1": user1,
    "user_2": user2,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "phone": phone,
    "name": name,
  };
}
