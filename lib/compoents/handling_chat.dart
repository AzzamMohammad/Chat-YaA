import 'dart:convert';
import 'package:get/get.dart';
import 'package:pusher_client/pusher_client.dart';

import '../config/pusher_config.dart';
import '../models/pusher_message.dart';
import '../modules/messages_chat/messages_chat_controller.dart';


void ListenToTheChatChannel(int UserId,String Token){
  print(UserId);
  LaravelEcho.instance.channel('chat${UserId}').listen('.sendMessage',
      (e){
    if(e is PusherEvent){
      if(e.data != null){
        // Symmetric listener
        // HandlingSymmetricChatMessage(e);

        // PGP listener
        // HandlingPGPChatMessage(e);


        // Digital Signature listener
        HandlingDigitalSignatureChatMessage(e);
      }
    }
      }
  ).error((err){
    print(err);
  });
}

bool LeaveChatChannel(int UserId){
  try{
    LaravelEcho.instance.leave('chat${UserId}');
    return true;
  }catch(e){
    print(e);
    return false;
  }
}


/** Symmetric */
void HandlingSymmetricChatMessage(PusherEvent event){
  PusherMessage pusherMessage = pusherMessageFromJson(event.data!);
  if(Get.currentRoute == '/messages_chat?res_id=${pusherMessage.message.senderId}'){
    MessagesChatController messagesChatController = Get.find();
    messagesChatController.AddSymmetricMessageToChat(pusherMessage.message);
  }
}

/** PGP */
void HandlingPGPChatMessage(PusherEvent event) {
  PusherMessage pusherMessage = pusherMessageFromJson(event.data!);
  if (Get.currentRoute ==
      '/messages_chat?res_id=${pusherMessage.message.senderId}') {
    MessagesChatController messagesChatController = Get.find();
    messagesChatController.AddPGPMessageToChat(pusherMessage.message);
  }
}
  /** Digital Signature */
void HandlingDigitalSignatureChatMessage(PusherEvent event){
  PusherMessage pusherMessage = pusherMessageFromJson(event.data!);
  if(Get.currentRoute == '/messages_chat?res_id=${pusherMessage.message.senderId}'){
    MessagesChatController messagesChatController = Get.find();
    messagesChatController.AddDigitalSignatureMessageToChat(pusherMessage.message);
  }
}




