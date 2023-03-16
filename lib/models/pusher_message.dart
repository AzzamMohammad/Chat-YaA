import 'dart:convert';

PusherMessage pusherMessageFromJson(String str) => PusherMessage.fromJson(json.decode(str));

String pusherMessageToJson(PusherMessage data) => json.encode(data.toJson());

class PusherMessage {
  PusherMessage({
    required this.receive,
    required this.message,
  });

  int receive;
  ReceiveMessage message;

  factory PusherMessage.fromJson(Map<String, dynamic> json) => PusherMessage(
    receive: json["receive"],
    message: ReceiveMessage.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "receive": receive,
    "message": message.toJson(),
  };
}

class ReceiveMessage {
  ReceiveMessage({
    required this.message,
     this.mac,
    this.signature,
    required this.chatId,
    required this.receiverId,
    required this.id,
    required this.senderId,
  });

  String message;
  dynamic mac;
  dynamic signature;
  String chatId;
  int receiverId;
  int id;
  int senderId;

  factory ReceiveMessage.fromJson(Map<String, dynamic> json) => ReceiveMessage(
    message: json["message"],
    mac: json["MAC"],
    signature: json["signature"],
    chatId: json["chat_id"],
    receiverId: json["receiver_id"],
    id: json["id"],
    senderId: json["sender_id"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "MAC": mac,
    "signature": signature,
    "chat_id": chatId,
    "receiver_id": receiverId,
    "id": id,
    "sender_id": senderId,
  };
}
