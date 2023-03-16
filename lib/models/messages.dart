import 'dart:convert';
import 'package:get/get.dart';

Messages messagesFromJson(String str) => Messages.fromJson(json.decode(str));

String messagesToJson(Messages data) => json.encode(data.toJson());

class Messages {
  Messages({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
    required this.ChatId,
  });

  bool status;
  String errNum;
  String msg;
  int ChatId;
  dynamic data;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    ChatId: json["chat_id"],
    data:json["Data"]!= null ? List<Message>.from(json["Data"].map((x) => Message.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "chat_id": ChatId,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.seen,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    this.SendingLevel
  }){
   if(SendingLevel == null)
     SendingLevel = 'arrived'.obs;
  }

  int id;
  int chatId;
  int senderId;
  int receiverId;
  int seen;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  var SendingLevel;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    chatId: json["chat_id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    seen: json["seen"],
    message: json["message"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat_id": chatId,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "seen": seen,
    "message": message,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
