import 'package:get/get.dart';
import 'package:secur_chat/modules/messages_chat/messages_chat_controller.dart';

class MessagesChatBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<MessagesChatController>(MessagesChatController());
  }

}