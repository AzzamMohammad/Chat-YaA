import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  dynamic data;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: json["Data"] != null? List<User>.from(json["Data"].map((x) => User.fromJson(x))):List<User>.from([]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class User {
  User({
    required this.id,
    required this.phone,
    required this.name,
  });

  int id;
  int phone;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    phone: json["phone"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "name": name,
  };
}
