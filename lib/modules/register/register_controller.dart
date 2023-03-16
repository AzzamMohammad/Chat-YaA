import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:secur_chat/modules/register/register_server.dart';

import '../../models/person.dart';
import '../../storage/shared_data.dart';

class RegisterController extends GetxController{
  late TextEditingController PhoneNumberController ;
  late TextEditingController PassWordController ;
  late TextEditingController NameController ;
  late Person person;
  late String PhoneNumber;
  late String UserName;
  late String UserPassword;
  late bool state;
  late String message;
  late SharedData sharedData;
  late RegisterServer registerServer ;

  @override
  void onInit() {
    PhoneNumberController = TextEditingController();
    PassWordController = TextEditingController();
    NameController = TextEditingController();
    PhoneNumber = '';
    UserName = '';
    UserPassword = '';
    state = false;
    message ='';
    registerServer = RegisterServer();
    sharedData = SharedData();
    super.onInit();
  }

  @override
  void dispose() {
    PhoneNumberController.dispose();
    PassWordController.dispose();
    super.dispose();
  }
  Future <void> RegisterClicked()async{
    person = Person(PhoneNumber: PhoneNumber, Password: UserPassword,Name: UserName);
    state = await registerServer.SendRegisterRequest(person);
    message = registerServer.message;
  }

}