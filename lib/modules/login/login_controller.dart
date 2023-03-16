
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../compoents/handling_chat.dart';
import '../../config/pusher_config.dart';
import '../../models/person.dart';
import '../../storage/shared_data.dart';
import 'login_server.dart';

class LoginController extends GetxController{
  late TextEditingController PhoneNumberController ;
  late TextEditingController PassWordController ;
  late Person person;
  late String PhoneNumber;
  late String UserPassword;
  late bool state;
  late String message;
  late SharedData sharedData;
  late LoginServer loginServer;
  late String Token;
  late int Id;

  @override
  void onInit() async {
    PhoneNumberController = TextEditingController();
    PassWordController = TextEditingController();
    PhoneNumber = '';
    UserPassword = '';
    state = false;
    message ='';
    loginServer = LoginServer();
    sharedData = SharedData();
    Token = '';
    Id = 0;
    Token = await sharedData.GetToken();
    Id = await sharedData.GetId();
    super.onInit();
  }

  @override
  void dispose() {
    PhoneNumberController.dispose();
    PassWordController.dispose();
    super.dispose();
  }

  Future<void> LoginClicked()async{
    person = Person(PhoneNumber: PhoneNumber, Password: UserPassword);
    state = await loginServer.SendLoginRequest(person,sharedData);
    if(state){
      Token = await sharedData.GetToken();
      Id = await sharedData.GetId();
      // state = await loginServer.HandlingParametersForPGP(Token);
      state = await loginServer.HandlingParametersForDigitalSignature(Token);
      message = loginServer.message;
    }
    if(state){
      LaravelEcho.init(Token: Token);
      ListenToTheChatChannel(Id,Token);
      print(Id);
    }
    message = loginServer.message;
  }


}