
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:secur_chat/modules/home/home_server.dart';
import 'package:secur_chat/storage/shared_data.dart';

import '../../models/chats.dart';
import '../../models/users.dart';



class HomeController extends GetxController {
  late String Message;
  late String Token;
  late SharedData sharedData;
  late bool State;
  late var UsersListIsLoad;
  late List<User> UsersList;
  late HomeServer homeServer;
  late List<chat> ChatsList;
  late var ChatsListIsLoad;
  late int IdUser;



  @override
  void onInit() async {
    Message = '';
    State = false;
    UsersListIsLoad = false.obs;
    UsersList = [];
    ChatsListIsLoad = false.obs;
    ChatsList = [];
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    homeServer = HomeServer();
    IdUser = await sharedData.GetId();
    super.onInit();
  }

  @override
  void onReady() {
  GetChatsList();
  super.onReady();
  }



  Future<void> GetUsers()async{
    State = false;
    UsersList = await homeServer.GetUsersList(Token);
    UsersListIsLoad(true);
  }

  Future<void> GetChatsList()async{
    State = false;
    ChatsList = await homeServer.GetChatsList(Token);
    ChatsListIsLoad(true);
  }

}