import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secur_chat/modules/splash/splash_server.dart';

import '../../compoents/handling_chat.dart';
import '../../compoents/loading.dart';
import '../../config/pusher_config.dart';
import '../../constant.dart';
import '../../storage/shared_data.dart';

class SplashController extends GetxController{
  late String PhoneNumber;
  late String UserPassword;
  late SharedData sharedData;
  late var IsLoaded;
  late bool State;
  late SplashServer splashServer;
  late String Message;
  late String Token;
  late int Id;
  late LoadingMessage loadingMessage;


  @override
  void onInit() async{
    IsLoaded = false.obs;
    State = false;
    Message = '';
    splashServer = SplashServer();
    sharedData = SharedData();
    loadingMessage = LoadingMessage();
    PhoneNumber = await sharedData.GetPhoneNumber();
    UserPassword = await sharedData.GetPassword();
    Token = await sharedData.GetToken();
    Id = await sharedData.GetId();
    super.onInit();
  }

  @override
  void onReady() {
    // GoToWithPGP();
    GoToWithDigitalSignature();
    super.onReady();
  }

  void GoToWithPGP()async{
    if(PhoneNumber != '' && UserPassword != ''){
      State = await splashServer.SendLoginRequest(PhoneNumber, UserPassword, sharedData);
      Message = splashServer.message;
    }
    if(State){
      Token = await sharedData.GetToken();
      Id = await sharedData.GetId();
      State = await splashServer.HandlingParametersForPGP(Token);
      Message = splashServer.message;
    }
    if(State){
      LaravelEcho.init(Token: Token);
      ListenToTheChatChannel(Id,Token);
      print(Id);
      Get.offAllNamed('/home');
    }

    else{
      loadingMessage.DisplayToast(
          Color(0xffDD5353),
          Colors.white,
          Colors.white,
          Message,
          true);
      Get.offAllNamed('/register');
    }

  }


  void GoToWithDigitalSignature()async{
    print(privateKey);
    print(publicKey);
    if(PhoneNumber != '' && UserPassword != ''){
      State = await splashServer.SendLoginRequest(PhoneNumber, UserPassword, sharedData);
      Message = splashServer.message;
    }
    if(State){
      Token = await sharedData.GetToken();
      Id = await sharedData.GetId();
      State = await splashServer.HandlingParametersForDigitalSignature(Token);
    }
    if(State){
      LaravelEcho.init(Token: Token);
      ListenToTheChatChannel(Id,Token);
      print(Id);
      Get.offAllNamed('/home');
    }

    else{
      loadingMessage.DisplayToast(
          Color(0xffDD5353),
          Colors.white,
          Colors.white,
          Message,
          true);
      Get.offAllNamed('/register');
    }

  }
}
