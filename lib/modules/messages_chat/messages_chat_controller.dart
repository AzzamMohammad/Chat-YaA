import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:secur_chat/modules/messages_chat/messages_chat_server.dart';
import 'package:secur_chat/storage/shared_data.dart';

import '../../models/messages.dart';
import '../../models/pusher_message.dart';
import 'encrypt_server/PGP_server.dart';
import 'encrypt_server/digital_ignature_server.dart';
import 'encrypt_server/symmetric_server.dart';

class MessagesChatController extends GetxController{
  late int ResId;
  late String ResName;
  late int ResPhone;
  late int MyId;
  late int ChatId;
  late String Token;
  late SharedData sharedData;
  late bool State;
  late String MessageContent;
  late TextEditingController SendFieldController;
  late List<Message> MessagesList;
  late MessagesChatServer messagesChatServer;
  late var MessagesListIsLoad;
  late var NumberOfMessageInChat ;


  //////////////////

  late SymmetricServer symmetricServer ;
  late String SecretKay;


  //////////////////

  late PGPServer pgpServer;
  late String PGPPrivateKay;

  /////////////////
  late DigitalSignatureServer digitalSignatureServer;




  @override
  void onInit() async {

    ResName = Get.arguments['res_name'];
    ResPhone = Get.arguments['res_phone'];
    ResId =int.parse(Get.parameters['res_id']!);
    ChatId = 8;
    MessagesList = [];
    MessageContent = '';
    NumberOfMessageInChat = 0.obs;
    sharedData = SharedData();
    messagesChatServer = MessagesChatServer();
    MessagesListIsLoad = false.obs;
    SendFieldController = TextEditingController();
    Token = await sharedData.GetToken();
    MyId = await sharedData.GetId();
    /////////////////////
    symmetricServer = SymmetricServer();
    SecretKay = await sharedData.GetSecretKay();

    ////////////////////
    pgpServer = PGPServer();
    PGPPrivateKay = await sharedData.GetPGPPrivateKay();

    ///////////////////

    digitalSignatureServer = DigitalSignatureServer();
    super.onInit();
  }

  @override
  void onReady() {

    GetAllMessagesList();
    super.onReady();
  }

  @override
  void dispose() {
    SendFieldController.dispose();
    super.dispose();
  }

  Future<void> GetAllMessagesList()async{
    State = false;
    MessagesList = await messagesChatServer.GetChatsList(Token,ResId);
    ChatId = messagesChatServer.ChatId;
    NumberOfMessageInChat(MessagesList.length);
    MessagesListIsLoad(true);
  }

  Future<void> SendMessage()async{
    Message NewMessage = Message(id: 0, chatId: ChatId, senderId: MyId, receiverId: 0, seen: 1, message: MessageContent, createdAt: DateTime.now(), updatedAt: DateTime.now(),SendingLevel: 'sending'.obs);
    MessagesList.insert(0, NewMessage);
    NumberOfMessageInChat(NumberOfMessageInChat.value +1);
    SendFieldController.clear();
    // State = await symmetricServer.EncryptSymmetricMessage(Token,ChatId,MessageContent,SecretKay);
    // State = await pgpServer.EncryptPGPMessage(Token,ChatId,MessageContent,PGPPrivateKay);
    State = await digitalSignatureServer.EncryptDigitalSignatureMessage(Token,ChatId,MessageContent);
    if(State){
      MessagesList.first.SendingLevel('arrived');
    }else{
      print(symmetricServer.Message);
    }
  }


   /////////////////////////////////////////
  /** Handling symmetric message */
  void AddSymmetricMessageToChat(ReceiveMessage receiveMessage){
    String DecodeMessage = symmetricServer.DecodeSymmetricMessage(receiveMessage.message,receiveMessage.mac,SecretKay);
    if(DecodeMessage == ''){
      print('Un known sender');
      return;
    }
    Message NewMessage = Message(id: receiveMessage.id, chatId: int.parse(receiveMessage.chatId), senderId: receiveMessage.senderId, receiverId: receiveMessage.receiverId, seen: 1, message: DecodeMessage, createdAt: DateTime.now(), updatedAt: DateTime.now(),SendingLevel: 'arrived'.obs);
    MessagesList.insert(0, NewMessage);
    NumberOfMessageInChat(NumberOfMessageInChat.value +1);
  }


  /////////////////////////////////////////
  /** Handling PGP message */
  void AddPGPMessageToChat(ReceiveMessage receiveMessage){
    String DecodeMessage = pgpServer.DecodePGPMessage(receiveMessage.message,PGPPrivateKay);
    Message NewMessage = Message(id: receiveMessage.id, chatId: int.parse(receiveMessage.chatId), senderId: receiveMessage.senderId, receiverId: receiveMessage.receiverId, seen: 1, message: DecodeMessage, createdAt: DateTime.now(), updatedAt: DateTime.now(),SendingLevel: 'arrived'.obs);
    MessagesList.insert(0, NewMessage);
    NumberOfMessageInChat(NumberOfMessageInChat.value +1);
  }

  /////////////////////////////////////////
  /** Handling PGP message */
  void AddDigitalSignatureMessageToChat(ReceiveMessage receiveMessage){
    String DecodeMessage = digitalSignatureServer.DecodeDigitalSignatureMessage(receiveMessage.message,receiveMessage.message);
    Message NewMessage = Message(id: receiveMessage.id, chatId: int.parse(receiveMessage.chatId), senderId: receiveMessage.senderId, receiverId: receiveMessage.receiverId, seen: 1, message: DecodeMessage, createdAt: DateTime.now(), updatedAt: DateTime.now(),SendingLevel: 'arrived'.obs);
    MessagesList.insert(0, NewMessage);
    NumberOfMessageInChat(NumberOfMessageInChat.value +1);
  }

}